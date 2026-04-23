package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

type FragilityRecord struct {
	Country                    string
	Region                     string
	ShockExposureIndex         float64
	ClimateRiskIndex           float64
	FoodSystemStressIndex      float64
	InstitutionalCapacityIndex float64
	InfrastructureResilienceIndex float64
	SocialProtectionIndex      float64
	InequalityBurdenIndex      float64
	FiscalSpaceIndex           float64
}

func parseRecord(row []string) (FragilityRecord, error) {
	if len(row) != 10 {
		return FragilityRecord{}, fmt.Errorf("invalid record length")
	}

	values := make([]float64, 8)
	for i, col := range row[2:] {
		value, err := strconv.ParseFloat(col, 64)
		if err != nil {
			return FragilityRecord{}, err
		}
		values[i] = value
	}

	return FragilityRecord{
		Country:                    row[0],
		Region:                     row[1],
		ShockExposureIndex:         values[0],
		ClimateRiskIndex:           values[1],
		FoodSystemStressIndex:      values[2],
		InstitutionalCapacityIndex: values[3],
		InfrastructureResilienceIndex: values[4],
		SocialProtectionIndex:      values[5],
		InequalityBurdenIndex:      values[6],
		FiscalSpaceIndex:           values[7],
	}, nil
}

func fragilityScore(record FragilityRecord) float64 {
	exposure := 0.40*record.ShockExposureIndex + 0.35*record.ClimateRiskIndex + 0.25*record.FoodSystemStressIndex
	resilience := 0.30*record.InstitutionalCapacityIndex + 0.25*record.InfrastructureResilienceIndex + 0.25*record.SocialProtectionIndex + 0.20*record.FiscalSpaceIndex
	return (0.60 * exposure) + (0.40 * record.InequalityBurdenIndex) - (0.50 * resilience)
}

func main() {
	file, err := os.Open("development_fragility_risk_data.csv")
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
		fmt.Printf("country=%s region=%s fragility_score=%.3f\n",
			record.Country, record.Region, score)
	}
}
