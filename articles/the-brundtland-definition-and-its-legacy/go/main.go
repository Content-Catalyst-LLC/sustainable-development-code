package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

type BrundtlandRecord struct {
	TerritoryName                 string
	CountryOrRegion               string
	TerritoryType                 string
	PresentNeedPressure           float64
	PovertyReductionSupport       float64
	EcologicalDegradation         float64
	FutureBurdenTransfer          float64
	InstitutionalDurability       float64
	IntergenerationalStewardship  float64
	AbsorptiveCapacityStress      float64
	TechnologyOrganisationConstraint float64
	DevelopmentLegitimacyAlignment float64
}

func parseRecord(row []string) (BrundtlandRecord, error) {
	if len(row) != 12 {
		return BrundtlandRecord{}, fmt.Errorf("invalid record length")
	}

	values := make([]float64, 9)
	for i, col := range row[3:] {
		value, err := strconv.ParseFloat(col, 64)
		if err != nil {
			return BrundtlandRecord{}, err
		}
		values[i] = value
	}

	return BrundtlandRecord{
		TerritoryName:                  row[0],
		CountryOrRegion:                row[1],
		TerritoryType:                  row[2],
		PresentNeedPressure:            values[0],
		PovertyReductionSupport:        values[1],
		EcologicalDegradation:          values[2],
		FutureBurdenTransfer:           values[3],
		InstitutionalDurability:        values[4],
		IntergenerationalStewardship:   values[5],
		AbsorptiveCapacityStress:       values[6],
		TechnologyOrganisationConstraint: values[7],
		DevelopmentLegitimacyAlignment: values[8],
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

func brundtlandRiskScore(record BrundtlandRecord) float64 {
	pressure := 0.16*record.PresentNeedPressure +
		0.14*(1-record.PovertyReductionSupport) +
		0.16*record.EcologicalDegradation +
		0.14*record.FutureBurdenTransfer +
		0.12*(1-record.InstitutionalDurability) +
		0.10*(1-record.IntergenerationalStewardship) +
		0.10*record.AbsorptiveCapacityStress +
		0.08*record.TechnologyOrganisationConstraint

	capacity := 0.24*record.PovertyReductionSupport +
		0.20*record.InstitutionalDurability +
		0.20*record.IntergenerationalStewardship +
		0.18*(1-record.AbsorptiveCapacityStress) +
		0.18*record.DevelopmentLegitimacyAlignment

	score := 0.50*pressure +
		0.30*(1-capacity) +
		0.20*record.FutureBurdenTransfer

	return clamp01(score)
}

func main() {
	file, err := os.Open("brundtland_definition_legacy_panel.csv")
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

		score := brundtlandRiskScore(record)
		fmt.Printf(
			"territory_name=%s territory_type=%s brundtland_legitimacy_risk_score=%.3f\n",
			record.TerritoryName, record.TerritoryType, score,
		)
	}
}
