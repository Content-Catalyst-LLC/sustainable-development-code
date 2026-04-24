package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

type SystemsRecord struct {
	TerritoryName               string
	CountryOrRegion             string
	TerritoryType               string
	InterdependenceIntensity    float64
	FeedbackRisk                float64
	DelayExposure               float64
	PathDependence              float64
	CrossScalePressure          float64
	EarthSystemStress           float64
	GovernanceFragmentation     float64
	CoordinationCapacity        float64
	InstitutionalIntegration    float64
	LeveragePointCapacity       float64
}

func parseRecord(row []string) (SystemsRecord, error) {
	if len(row) != 13 {
		return SystemsRecord{}, fmt.Errorf("invalid record length")
	}

	values := make([]float64, 10)
	for i, col := range row[3:] {
		value, err := strconv.ParseFloat(col, 64)
		if err != nil {
			return SystemsRecord{}, err
		}
		values[i] = value
	}

	return SystemsRecord{
		TerritoryName:            row[0],
		CountryOrRegion:          row[1],
		TerritoryType:            row[2],
		InterdependenceIntensity: values[0],
		FeedbackRisk:             values[1],
		DelayExposure:            values[2],
		PathDependence:           values[3],
		CrossScalePressure:       values[4],
		EarthSystemStress:        values[5],
		GovernanceFragmentation:  values[6],
		CoordinationCapacity:     values[7],
		InstitutionalIntegration: values[8],
		LeveragePointCapacity:    values[9],
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

func systemsFragilityScore(record SystemsRecord) float64 {
	systemsPressure := 0.16*record.InterdependenceIntensity +
		0.16*record.FeedbackRisk +
		0.14*record.DelayExposure +
		0.14*record.PathDependence +
		0.14*record.CrossScalePressure +
		0.14*record.EarthSystemStress +
		0.12*record.GovernanceFragmentation

	systemsCapacity := 0.36*record.CoordinationCapacity +
		0.34*record.InstitutionalIntegration +
		0.30*record.LeveragePointCapacity

	score := 0.55*systemsPressure +
		0.25*(1-systemsCapacity) +
		0.20*record.GovernanceFragmentation

	return clamp01(score)
}

func main() {
	file, err := os.Open("sustainable_development_systems_problem_panel.csv")
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

		score := systemsFragilityScore(record)
		fmt.Printf(
			"territory_name=%s territory_type=%s systems_fragility_score=%.3f\n",
			record.TerritoryName, record.TerritoryType, score,
		)
	}
}
