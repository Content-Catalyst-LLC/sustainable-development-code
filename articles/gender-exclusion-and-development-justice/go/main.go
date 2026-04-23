package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

type GenderRecord struct {
	TerritoryName            string
	CountryOrRegion          string
	TerritoryType            string
	EducationAccess          float64
	HealthAutonomy           float64
	EconomicParticipation    float64
	CareBurden               float64
	ViolenceExposure         float64
	InstitutionalPowerGap    float64
	PropertyRightsGap        float64
	GovernanceCapacity       float64
	GenderTransitionReadiness float64
}

func parseRecord(row []string) (GenderRecord, error) {
	if len(row) != 12 {
		return GenderRecord{}, fmt.Errorf("invalid record length")
	}

	values := make([]float64, 9)
	for i, col := range row[3:] {
		value, err := strconv.ParseFloat(col, 64)
		if err != nil {
			return GenderRecord{}, err
		}
		values[i] = value
	}

	return GenderRecord{
		TerritoryName:             row[0],
		CountryOrRegion:           row[1],
		TerritoryType:             row[2],
		EducationAccess:           values[0],
		HealthAutonomy:            values[1],
		EconomicParticipation:     values[2],
		CareBurden:                values[3],
		ViolenceExposure:          values[4],
		InstitutionalPowerGap:     values[5],
		PropertyRightsGap:         values[6],
		GovernanceCapacity:        values[7],
		GenderTransitionReadiness: values[8],
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

func genderJusticeRiskScore(record GenderRecord) float64 {
	substantiveFreedom := 0.24*record.EducationAccess +
		0.24*record.HealthAutonomy +
		0.20*record.EconomicParticipation +
		0.16*(1-record.ViolenceExposure) +
		0.16*(1-record.PropertyRightsGap)

	genderExclusion := 0.22*record.CareBurden +
		0.22*record.ViolenceExposure +
		0.20*record.InstitutionalPowerGap +
		0.18*record.PropertyRightsGap +
		0.18*(1-record.EconomicParticipation)

	governance := 0.55*record.GovernanceCapacity +
		0.45*record.GenderTransitionReadiness

	score := 0.40*genderExclusion +
		0.25*(1-substantiveFreedom) +
		0.20*record.ViolenceExposure +
		0.15*(1-governance)

	return clamp01(score)
}

func main() {
	file, err := os.Open("gender_exclusion_development_justice_panel.csv")
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

		score := genderJusticeRiskScore(record)
		fmt.Printf(
			"territory_name=%s territory_type=%s gender_development_justice_risk_score=%.3f\n",
			record.TerritoryName, record.TerritoryType, score,
		)
	}
}
