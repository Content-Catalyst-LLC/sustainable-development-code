package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

type CapabilityRecord struct {
	TerritoryName               string
	CountryOrRegion             string
	TerritoryType               string
	HealthAccess                float64
	EducationAccess             float64
	ServiceQuality              float64
	FinancialHardshipRisk       float64
	LearningDeprivation         float64
	LifeCourseVulnerability     float64
	InequalityExclusion         float64
	GovernanceCapacity          float64
	CapabilityTransitionReadiness float64
}

func parseRecord(row []string) (CapabilityRecord, error) {
	if len(row) != 12 {
		return CapabilityRecord{}, fmt.Errorf("invalid record length")
	}

	values := make([]float64, 9)
	for i, col := range row[3:] {
		value, err := strconv.ParseFloat(col, 64)
		if err != nil {
			return CapabilityRecord{}, err
		}
		values[i] = value
	}

	return CapabilityRecord{
		TerritoryName:                 row[0],
		CountryOrRegion:               row[1],
		TerritoryType:                 row[2],
		HealthAccess:                  values[0],
		EducationAccess:               values[1],
		ServiceQuality:                values[2],
		FinancialHardshipRisk:         values[3],
		LearningDeprivation:           values[4],
		LifeCourseVulnerability:       values[5],
		InequalityExclusion:           values[6],
		GovernanceCapacity:            values[7],
		CapabilityTransitionReadiness: values[8],
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

func capabilityRiskScore(record CapabilityRecord) float64 {
	capabilityExpansion := 0.22*record.HealthAccess +
		0.22*record.EducationAccess +
		0.20*record.ServiceQuality +
		0.18*record.GovernanceCapacity +
		0.18*record.CapabilityTransitionReadiness

	capabilityErosion := 0.22*record.FinancialHardshipRisk +
		0.20*record.LearningDeprivation +
		0.20*record.LifeCourseVulnerability +
		0.20*record.InequalityExclusion +
		0.18*(1-record.ServiceQuality)

	governance := 0.55*record.GovernanceCapacity +
		0.45*record.CapabilityTransitionReadiness

	score := 0.40*capabilityErosion +
		0.25*(1-capabilityExpansion) +
		0.20*record.FinancialHardshipRisk +
		0.15*(1-governance)

	return clamp01(score)
}

func main() {
	file, err := os.Open("health_education_capability_panel.csv")
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

		score := capabilityRiskScore(record)
		fmt.Printf(
			"territory_name=%s territory_type=%s human_capability_risk_score=%.3f\n",
			record.TerritoryName, record.TerritoryType, score,
		)
	}
}
