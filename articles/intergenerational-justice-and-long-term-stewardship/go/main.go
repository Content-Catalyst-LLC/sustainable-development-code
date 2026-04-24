package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

type IntergenerationalRecord struct {
	TerritoryName               string
	CountryOrRegion             string
	TerritoryType               string
	FutureBurdenTransfer        float64
	EcologicalDegradation       float64
	InstitutionalErosion        float64
	PublicDebtLockIn            float64
	InfrastructureLockIn        float64
	ClimateRiskTransfer         float64
	FutureRepresentationGap     float64
	GovernanceCapacity          float64
	PrecautionaryPlanning       float64
	ResiliencePreservation      float64
	JusticeExposure             float64
}

func parseRecord(row []string) (IntergenerationalRecord, error) {
	if len(row) != 14 {
		return IntergenerationalRecord{}, fmt.Errorf("invalid record length")
	}

	values := make([]float64, 11)
	for i, col := range row[3:] {
		value, err := strconv.ParseFloat(col, 64)
		if err != nil {
			return IntergenerationalRecord{}, err
		}
		values[i] = value
	}

	return IntergenerationalRecord{
		TerritoryName:           row[0],
		CountryOrRegion:         row[1],
		TerritoryType:           row[2],
		FutureBurdenTransfer:    values[0],
		EcologicalDegradation:   values[1],
		InstitutionalErosion:    values[2],
		PublicDebtLockIn:        values[3],
		InfrastructureLockIn:    values[4],
		ClimateRiskTransfer:     values[5],
		FutureRepresentationGap: values[6],
		GovernanceCapacity:      values[7],
		PrecautionaryPlanning:   values[8],
		ResiliencePreservation:  values[9],
		JusticeExposure:         values[10],
	}, nil
}

func clamp01(x float64) float64 {
	if x < 0 {
		return 0
	}
	if x > 1 {
		return 1
	}
	return x
}

func intergenerationalJusticeRiskScore(record IntergenerationalRecord) float64 {
	futureBurden := 0.18*record.FutureBurdenTransfer +
		0.16*record.EcologicalDegradation +
		0.14*record.InstitutionalErosion +
		0.12*record.PublicDebtLockIn +
		0.12*record.InfrastructureLockIn +
		0.14*record.ClimateRiskTransfer +
		0.14*record.FutureRepresentationGap

	stewardshipCapacity := 0.35*record.GovernanceCapacity +
		0.30*record.PrecautionaryPlanning +
		0.25*record.ResiliencePreservation +
		0.10*(1-record.JusticeExposure)

	score := 0.50*futureBurden +
		0.20*(1-stewardshipCapacity) +
		0.15*record.EcologicalDegradation +
		0.10*record.FutureRepresentationGap +
		0.05*record.JusticeExposure

	return clamp01(score)
}

func main() {
	file, err := os.Open("intergenerational_justice_long_term_stewardship_panel.csv")
	if err != nil {
		fmt.Println("Error opening CSV:", err)
		return
	}
	defer file.Close()

	reader := csv.NewReader(file)
	rows, err := reader.ReadAll()
	if err != nil {
		fmt.Println("Error reading CSV:", err)
		return
	}

	for i, row := range rows {
		if i == 0 {
			continue
		}

		record, err := parseRecord(row)
		if err != nil {
			fmt.Println("Parse error:", err)
			continue
		}

		score := intergenerationalJusticeRiskScore(record)
		fmt.Printf(
			"territory_name=%s territory_type=%s intergenerational_justice_risk_score=%.3f\n",
			record.TerritoryName, record.TerritoryType, score,
		)
	}
}
