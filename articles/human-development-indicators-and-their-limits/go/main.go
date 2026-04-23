package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

type IndicatorRecord struct {
	TerritoryName              string
	CountryOrRegion            string
	TerritoryType              string
	HDIAttainment              float64
	InequalityPenalty          float64
	GenderGap                  float64
	MultidimensionalPoverty    float64
	PlanetaryPressurePenalty   float64
	DataQualityConfidence      float64
	SubnationalVariation       float64
	SecurityExclusion          float64
	IndicatorCoverage          float64
}

func parseRecord(row []string) (IndicatorRecord, error) {
	if len(row) != 12 {
		return IndicatorRecord{}, fmt.Errorf("invalid record length")
	}

	values := make([]float64, 9)
	for i, col := range row[3:] {
		value, err := strconv.ParseFloat(col, 64)
		if err != nil {
			return IndicatorRecord{}, err
		}
		values[i] = value
	}

	return IndicatorRecord{
		TerritoryName:            row[0],
		CountryOrRegion:          row[1],
		TerritoryType:            row[2],
		HDIAttainment:            values[0],
		InequalityPenalty:        values[1],
		GenderGap:                values[2],
		MultidimensionalPoverty:  values[3],
		PlanetaryPressurePenalty: values[4],
		DataQualityConfidence:    values[5],
		SubnationalVariation:     values[6],
		SecurityExclusion:        values[7],
		IndicatorCoverage:        values[8],
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

func indicatorLimitRiskScore(record IndicatorRecord) float64 {
	headlineAttainment := 0.45*record.HDIAttainment +
		0.20*record.IndicatorCoverage +
		0.20*record.DataQualityConfidence +
		0.15*(1-record.PlanetaryPressurePenalty)

	hiddenBurden := 0.22*record.InequalityPenalty +
		0.20*record.GenderGap +
		0.20*record.MultidimensionalPoverty +
		0.18*record.SubnationalVariation +
		0.20*record.SecurityExclusion

	interpretiveRobustness := 0.40*record.DataQualityConfidence +
		0.35*record.IndicatorCoverage +
		0.25*(1-record.SubnationalVariation)

	score := 0.40*hiddenBurden +
		0.25*(1-interpretiveRobustness) +
		0.20*record.PlanetaryPressurePenalty +
		0.15*(1-headlineAttainment)

	return clamp01(score)
}

func main() {
	file, err := os.Open("human_development_indicators_panel.csv")
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

		score := indicatorLimitRiskScore(record)
		fmt.Printf(
			"territory_name=%s territory_type=%s indicator_limit_risk_score=%.3f\n",
			record.TerritoryName, record.TerritoryType, score,
		)
	}
}
