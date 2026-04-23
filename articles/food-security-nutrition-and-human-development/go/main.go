package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

type FoodRecord struct {
	TerritoryName                string
	CountryOrRegion              string
	TerritoryType                string
	FoodAccess                   float64
	HealthyDietAffordabilityStress float64
	NutritionQuality             float64
	PriceVolatility              float64
	ChildMaternalRisk            float64
	FoodSystemFragility          float64
	PovertyExposure              float64
	GovernanceCapacity           float64
	NutritionTransitionReadiness float64
}

func parseRecord(row []string) (FoodRecord, error) {
	if len(row) != 12 {
		return FoodRecord{}, fmt.Errorf("invalid record length")
	}

	values := make([]float64, 9)
	for i, col := range row[3:] {
		value, err := strconv.ParseFloat(col, 64)
		if err != nil {
			return FoodRecord{}, err
		}
		values[i] = value
	}

	return FoodRecord{
		TerritoryName:                row[0],
		CountryOrRegion:              row[1],
		TerritoryType:                row[2],
		FoodAccess:                   values[0],
		HealthyDietAffordabilityStress: values[1],
		NutritionQuality:             values[2],
		PriceVolatility:              values[3],
		ChildMaternalRisk:            values[4],
		FoodSystemFragility:          values[5],
		PovertyExposure:              values[6],
		GovernanceCapacity:           values[7],
		NutritionTransitionReadiness: values[8],
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

func foodDevelopmentRiskScore(record FoodRecord) float64 {
	nutritionCapability := 0.30*record.FoodAccess +
		0.26*record.NutritionQuality +
		0.16*record.GovernanceCapacity +
		0.14*record.NutritionTransitionReadiness +
		0.14*(1-record.HealthyDietAffordabilityStress)

	foodFragility := 0.22*record.HealthyDietAffordabilityStress +
		0.18*record.PriceVolatility +
		0.20*record.FoodSystemFragility +
		0.20*record.PovertyExposure +
		0.20*record.ChildMaternalRisk

	governance := 0.55*record.GovernanceCapacity +
		0.45*record.NutritionTransitionReadiness

	score := 0.40*foodFragility +
		0.25*(1-nutritionCapability) +
		0.20*record.HealthyDietAffordabilityStress +
		0.15*(1-governance)

	return clamp01(score)
}

func main() {
	file, err := os.Open("food_security_nutrition_panel.csv")
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

		score := foodDevelopmentRiskScore(record)
		fmt.Printf(
			"territory_name=%s territory_type=%s food_development_risk_score=%.3f\n",
			record.TerritoryName, record.TerritoryType, score,
		)
	}
}
