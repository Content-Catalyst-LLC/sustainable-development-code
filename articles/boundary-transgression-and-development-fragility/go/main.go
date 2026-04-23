package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

type BoundaryRecord struct {
	Country                     string
	Region                      string
	ClimatePressureIndex        float64
	FreshwaterPressureIndex     float64
	BiospherePressureIndex      float64
	LandSystemPressureIndex     float64
	NutrientPressureIndex       float64
	AdaptiveCapacityIndex       float64
	InfrastructureResilienceIndex float64
	EquityProtectionIndex       float64
	InstitutionalCapacityIndex  float64
}

func parseRecord(row []string) (BoundaryRecord, error) {
	if len(row) != 11 {
		return BoundaryRecord{}, fmt.Errorf("invalid record length")
	}

	values := make([]float64, 9)
	for i, col := range row[2:] {
		value, err := strconv.ParseFloat(col, 64)
		if err != nil {
			return BoundaryRecord{}, err
		}
		values[i] = value
	}

	return BoundaryRecord{
		Country:                      row[0],
		Region:                       row[1],
		ClimatePressureIndex:         values[0],
		FreshwaterPressureIndex:      values[1],
		BiospherePressureIndex:       values[2],
		LandSystemPressureIndex:      values[3],
		NutrientPressureIndex:        values[4],
		AdaptiveCapacityIndex:        values[5],
		InfrastructureResilienceIndex: values[6],
		EquityProtectionIndex:        values[7],
		InstitutionalCapacityIndex:   values[8],
	}, nil
}

func fragilityScore(record BoundaryRecord) float64 {
	pressure := 0.25*record.ClimatePressureIndex +
		0.20*record.FreshwaterPressureIndex +
		0.20*record.BiospherePressureIndex +
		0.20*record.LandSystemPressureIndex +
		0.15*record.NutrientPressureIndex

	capacity := 0.35*record.AdaptiveCapacityIndex +
		0.25*record.InstitutionalCapacityIndex +
		0.20*record.InfrastructureResilienceIndex +
		0.20*record.EquityProtectionIndex

	return 0.70*pressure - 0.50*capacity
}

func main() {
	file, err := os.Open("boundary_pressure_fragility_data.csv")
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

		score := fragilityScore(record)
		fmt.Printf("country=%s region=%s ecological_fragility_score=%.3f\n",
			record.Country, record.Region, score)
	}
}
