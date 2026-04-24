package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

type SustainableDevelopmentRecord struct {
	TerritoryName               string
	CountryOrRegion             string
	TerritoryType               string
	PresentDeprivation          float64
	HumanWellbeingSupport       float64
	EcologicalStress            float64
	FutureBurdenTransfer        float64
	InstitutionalDurability     float64
	SystemsInterdependenceRisk  float64
	LongRunViability            float64
	GovernanceCapacity          float64
	PlanetaryConstraintExposure float64
	DevelopmentAlignment        float64
}

func parseRecord(row []string) (SustainableDevelopmentRecord, error) {
	if len(row) != 13 {
		return SustainableDevelopmentRecord{}, fmt.Errorf("invalid record length")
	}

	values := make([]float64, 10)
	for i, col := range row[3:] {
		value, err := strconv.ParseFloat(col, 64)
		if err != nil {
			return SustainableDevelopmentRecord{}, err
		}
		values[i] = value
	}

	return SustainableDevelopmentRecord{
		TerritoryName:               row[0],
		CountryOrRegion:             row[1],
		TerritoryType:               row[2],
		PresentDeprivation:          values[0],
		HumanWellbeingSupport:       values[1],
		EcologicalStress:            values[2],
		FutureBurdenTransfer:        values[3],
		InstitutionalDurability:     values[4],
		SystemsInterdependenceRisk:  values[5],
		LongRunViability:            values[6],
		GovernanceCapacity:          values[7],
		PlanetaryConstraintExposure: values[8],
		DevelopmentAlignment:        values[9],
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

func sustainableDevelopmentRiskScore(record SustainableDevelopmentRecord) float64 {
	pressure := 0.16*record.PresentDeprivation +
		0.14*(1-record.HumanWellbeingSupport) +
		0.14*record.EcologicalStress +
		0.12*record.FutureBurdenTransfer +
		0.10*(1-record.InstitutionalDurability) +
		0.10*record.SystemsInterdependenceRisk +
		0.12*(1-record.LongRunViability) +
		0.12*record.PlanetaryConstraintExposure

	capacity := 0.22*record.HumanWellbeingSupport +
		0.20*record.InstitutionalDurability +
		0.18*record.LongRunViability +
		0.18*record.GovernanceCapacity +
		0.12*(1-record.PlanetaryConstraintExposure) +
		0.10*record.DevelopmentAlignment

	score := 0.50*pressure +
		0.30*(1-capacity) +
		0.20*record.FutureBurdenTransfer

	return clamp01(score)
}

func main() {
	file, err := os.Open("what_is_sustainable_development_panel.csv")
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

		score := sustainableDevelopmentRiskScore(record)
		fmt.Printf(
			"territory_name=%s territory_type=%s sustainable_development_risk_score=%.3f\n",
			record.TerritoryName, record.TerritoryType, score,
		)
	}
}
