package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

type OvershootRecord struct {
	TerritoryName             string
	CountryOrRegion           string
	TerritoryType             string
	GrowthPressure            float64
	ThroughputPressure        float64
	ResourceDepletion         float64
	WasteAbsorptiveStress     float64
	PlanetaryPressure         float64
	DelayRecognitionRisk      float64
	InfrastructureLockin      float64
	GovernanceFragility       float64
	AdaptiveCapacity          float64
	WelfareConversion         float64
}

func parseRecord(row []string) (OvershootRecord, error) {
	if len(row) != 13 {
		return OvershootRecord{}, fmt.Errorf("invalid record length")
	}

	values := make([]float64, 10)
	for i, col := range row[3:] {
		value, err := strconv.ParseFloat(col, 64)
		if err != nil {
			return OvershootRecord{}, err
		}
		values[i] = value
	}

	return OvershootRecord{
		TerritoryName:         row[0],
		CountryOrRegion:       row[1],
		TerritoryType:         row[2],
		GrowthPressure:        values[0],
		ThroughputPressure:    values[1],
		ResourceDepletion:     values[2],
		WasteAbsorptiveStress: values[3],
		PlanetaryPressure:     values[4],
		DelayRecognitionRisk:  values[5],
		InfrastructureLockin:  values[6],
		GovernanceFragility:   values[7],
		AdaptiveCapacity:      values[8],
		WelfareConversion:     values[9],
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

func overshootRiskScore(record OvershootRecord) float64 {
	overshootPressure := 0.16*record.GrowthPressure +
		0.16*record.ThroughputPressure +
		0.14*record.ResourceDepletion +
		0.14*record.WasteAbsorptiveStress +
		0.14*record.PlanetaryPressure +
		0.13*record.DelayRecognitionRisk +
		0.13*record.InfrastructureLockin

	score := 0.50*overshootPressure +
		0.20*record.GovernanceFragility +
		0.15*(1-record.AdaptiveCapacity) +
		0.15*(1-record.WelfareConversion)

	return clamp01(score)
}

func main() {
	file, err := os.Open("growth_limits_overshoot_panel.csv")
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

		score := overshootRiskScore(record)
		fmt.Printf(
			"territory_name=%s territory_type=%s overshoot_risk_score=%.3f\n",
			record.TerritoryName, record.TerritoryType, score,
		)
	}
}
