package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

type SafeOperatingSpaceRecord struct {
	TerritoryName                   string
	CountryOrRegion                 string
	TerritoryType                   string
	ClimateBoundaryPressure         float64
	BiosphereBoundaryPressure       float64
	LandSystemPressure              float64
	FreshwaterPressure              float64
	BiogeochemicalPressure          float64
	NovelEntitiesPressure           float64
	OceanAcidificationPressure      float64
	ResilienceLoss                  float64
	GovernabilityStrain             float64
	AdaptationCapacity              float64
	JusticeExposure                 float64
}

func parseRecord(row []string) (SafeOperatingSpaceRecord, error) {
	if len(row) != 14 {
		return SafeOperatingSpaceRecord{}, fmt.Errorf("invalid record length")
	}

	values := make([]float64, 11)
	for i, col := range row[3:] {
		value, err := strconv.ParseFloat(col, 64)
		if err != nil {
			return SafeOperatingSpaceRecord{}, err
		}
		values[i] = value
	}

	return SafeOperatingSpaceRecord{
		TerritoryName:              row[0],
		CountryOrRegion:            row[1],
		TerritoryType:              row[2],
		ClimateBoundaryPressure:    values[0],
		BiosphereBoundaryPressure:  values[1],
		LandSystemPressure:         values[2],
		FreshwaterPressure:         values[3],
		BiogeochemicalPressure:     values[4],
		NovelEntitiesPressure:      values[5],
		OceanAcidificationPressure: values[6],
		ResilienceLoss:             values[7],
		GovernabilityStrain:        values[8],
		AdaptationCapacity:         values[9],
		JusticeExposure:            values[10],
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

func longRunDevelopmentRiskScore(record SafeOperatingSpaceRecord) float64 {
	boundaryPressure := 0.16*record.ClimateBoundaryPressure +
		0.16*record.BiosphereBoundaryPressure +
		0.14*record.LandSystemPressure +
		0.14*record.FreshwaterPressure +
		0.14*record.BiogeochemicalPressure +
		0.13*record.NovelEntitiesPressure +
		0.13*record.OceanAcidificationPressure

	score := 0.50*boundaryPressure +
		0.20*record.ResilienceLoss +
		0.15*record.GovernabilityStrain +
		0.10*(1-record.AdaptationCapacity) +
		0.05*record.JusticeExposure

	return clamp01(score)
}

func main() {
	file, err := os.Open("safe_operating_space_long_run_development_panel.csv")
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

		score := longRunDevelopmentRiskScore(record)
		fmt.Printf(
			"territory_name=%s territory_type=%s safe_operating_space_risk_score=%.3f\n",
			record.TerritoryName, record.TerritoryType, score,
		)
	}
}
