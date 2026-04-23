package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

type UrbanRecord struct {
	TerritoryName           string
	CountryOrRegion         string
	TerritoryType           string
	HousingAdequacy         float64
	HousingAffordability    float64
	BasicServicesAccess     float64
	InformalityExclusion    float64
	MobilityAccess          float64
	ResilienceWeakness      float64
	JusticeExposure         float64
	GovernanceCapacity      float64
	UrbanTransitionReadiness float64
}

func parseRecord(row []string) (UrbanRecord, error) {
	if len(row) != 12 {
		return UrbanRecord{}, fmt.Errorf("invalid record length")
	}

	values := make([]float64, 9)
	for i, col := range row[3:] {
		value, err := strconv.ParseFloat(col, 64)
		if err != nil {
			return UrbanRecord{}, err
		}
		values[i] = value
	}

	return UrbanRecord{
		TerritoryName:            row[0],
		CountryOrRegion:          row[1],
		TerritoryType:            row[2],
		HousingAdequacy:          values[0],
		HousingAffordability:     values[1],
		BasicServicesAccess:      values[2],
		InformalityExclusion:     values[3],
		MobilityAccess:           values[4],
		ResilienceWeakness:       values[5],
		JusticeExposure:          values[6],
		GovernanceCapacity:       values[7],
		UrbanTransitionReadiness: values[8],
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

func urbanDevelopmentRiskScore(record UrbanRecord) float64 {
	urbanCapability := 0.28*record.HousingAdequacy +
		0.26*record.BasicServicesAccess +
		0.18*record.MobilityAccess +
		0.14*record.GovernanceCapacity +
		0.14*record.UrbanTransitionReadiness

	urbanFragility := 0.22*record.HousingAffordability +
		0.22*record.InformalityExclusion +
		0.20*record.ResilienceWeakness +
		0.18*record.JusticeExposure +
		0.18*(1-record.BasicServicesAccess)

	governance := 0.55*record.GovernanceCapacity +
		0.45*record.UrbanTransitionReadiness

	score := 0.40*urbanFragility +
		0.25*(1-urbanCapability) +
		0.20*record.HousingAffordability +
		0.15*(1-governance)

	return clamp01(score)
}

func main() {
	file, err := os.Open("urbanization_housing_services_panel.csv")
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

		score := urbanDevelopmentRiskScore(record)
		fmt.Printf(
			"territory_name=%s territory_type=%s urban_development_risk_score=%.3f\n",
			record.TerritoryName, record.TerritoryType, score,
		)
	}
}
