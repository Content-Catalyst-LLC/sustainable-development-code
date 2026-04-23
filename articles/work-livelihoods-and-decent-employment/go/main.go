package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

type WorkRecord struct {
	TerritoryName             string
	CountryOrRegion           string
	TerritoryType             string
	EmploymentAccess          float64
	InformalityRisk           float64
	PrecarityRisk             float64
	IncomeSecurity            float64
	SocialProtectionCoverage  float64
	LabourRightsExposure      float64
	YouthExclusion            float64
	GenderLivelihoodGap       float64
	TransitionReadiness       float64
}

func parseRecord(row []string) (WorkRecord, error) {
	if len(row) != 12 {
		return WorkRecord{}, fmt.Errorf("invalid record length")
	}

	values := make([]float64, 9)
	for i, col := range row[3:] {
		value, err := strconv.ParseFloat(col, 64)
		if err != nil {
			return WorkRecord{}, err
		}
		values[i] = value
	}

	return WorkRecord{
		TerritoryName:            row[0],
		CountryOrRegion:          row[1],
		TerritoryType:            row[2],
		EmploymentAccess:         values[0],
		InformalityRisk:          values[1],
		PrecarityRisk:            values[2],
		IncomeSecurity:           values[3],
		SocialProtectionCoverage: values[4],
		LabourRightsExposure:     values[5],
		YouthExclusion:           values[6],
		GenderLivelihoodGap:      values[7],
		TransitionReadiness:      values[8],
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

func decentEmploymentRiskScore(record WorkRecord) float64 {
	livelihoodSecurity := 0.30*record.EmploymentAccess +
		0.25*record.IncomeSecurity +
		0.25*record.SocialProtectionCoverage +
		0.20*(1-record.LabourRightsExposure)

	labourFragility := 0.24*record.InformalityRisk +
		0.24*record.PrecarityRisk +
		0.18*(1-record.IncomeSecurity) +
		0.17*record.YouthExclusion +
		0.17*record.GenderLivelihoodGap

	governance := 0.55*record.SocialProtectionCoverage +
		0.45*record.TransitionReadiness

	score := 0.40*labourFragility +
		0.25*(1-livelihoodSecurity) +
		0.20*record.LabourRightsExposure +
		0.15*(1-governance)

	return clamp01(score)
}

func main() {
	file, err := os.Open("work_livelihoods_panel.csv")
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

		score := decentEmploymentRiskScore(record)
		fmt.Printf(
			"territory_name=%s territory_type=%s decent_employment_risk_score=%.3f\n",
			record.TerritoryName, record.TerritoryType, score,
		)
	}
}
