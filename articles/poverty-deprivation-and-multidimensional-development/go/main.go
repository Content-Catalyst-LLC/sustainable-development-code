package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

type PovertyRecord struct {
	TerritoryName                           string
	CountryOrRegion                         string
	TerritoryType                           string
	IncomePoverty                           float64
	HousingDeprivation                      float64
	SanitationDeprivation                   float64
	ElectricityCookingFuelDeprivation       float64
	NutritionDeprivation                    float64
	LearningDeprivation                     float64
	ClimateExposure                         float64
	ChildVulnerability                      float64
	PublicGoodsAccess                       float64
	GovernanceCapacity                      float64
	PovertyTransitionReadiness              float64
}

func parseRecord(row []string) (PovertyRecord, error) {
	if len(row) != 14 {
		return PovertyRecord{}, fmt.Errorf("invalid record length")
	}

	values := make([]float64, 11)
	for i, col := range row[3:] {
		value, err := strconv.ParseFloat(col, 64)
		if err != nil {
			return PovertyRecord{}, err
		}
		values[i] = value
	}

	return PovertyRecord{
		TerritoryName:                     row[0],
		CountryOrRegion:                   row[1],
		TerritoryType:                     row[2],
		IncomePoverty:                     values[0],
		HousingDeprivation:                values[1],
		SanitationDeprivation:             values[2],
		ElectricityCookingFuelDeprivation: values[3],
		NutritionDeprivation:              values[4],
		LearningDeprivation:               values[5],
		ClimateExposure:                   values[6],
		ChildVulnerability:                values[7],
		PublicGoodsAccess:                 values[8],
		GovernanceCapacity:                values[9],
		PovertyTransitionReadiness:        values[10],
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

func povertyRiskScore(record PovertyRecord) float64 {
	multidimensionalDeprivation := 0.12*record.IncomePoverty +
		0.14*record.HousingDeprivation +
		0.14*record.SanitationDeprivation +
		0.14*record.ElectricityCookingFuelDeprivation +
		0.14*record.NutritionDeprivation +
		0.14*record.LearningDeprivation +
		0.09*record.ClimateExposure +
		0.09*record.ChildVulnerability

	capabilitySupport := 0.35*record.PublicGoodsAccess +
		0.35*record.GovernanceCapacity +
		0.30*record.PovertyTransitionReadiness

	score := 0.45*multidimensionalDeprivation +
		0.20*record.ClimateExposure +
		0.15*record.ChildVulnerability +
		0.20*(1-capabilitySupport)

	return clamp01(score)
}

func main() {
	file, err := os.Open("poverty_multidimensional_development_panel.csv")
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

		score := povertyRiskScore(record)
		fmt.Printf(
			"territory_name=%s territory_type=%s poverty_reproduction_risk_score=%.3f\n",
			record.TerritoryName, record.TerritoryType, score,
		)
	}
}
