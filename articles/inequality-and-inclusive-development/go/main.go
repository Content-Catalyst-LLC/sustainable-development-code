package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

type InclusionRecord struct {
	TerritoryName                string
	CountryOrRegion              string
	TerritoryType                string
	EducationAccess              float64
	HealthAccess                 float64
	IncomeSecurity               float64
	PublicGoodsAccess            float64
	OpportunityBlockage          float64
	RiskExposure                 float64
	InstitutionalCapture         float64
	GovernanceCapacity           float64
	InclusiveTransitionReadiness float64
}

func parseRecord(row []string) (InclusionRecord, error) {
	if len(row) != 12 {
		return InclusionRecord{}, fmt.Errorf("invalid record length")
	}

	values := make([]float64, 9)
	for i, col := range row[3:] {
		value, err := strconv.ParseFloat(col, 64)
		if err != nil {
			return InclusionRecord{}, err
		}
		values[i] = value
	}

	return InclusionRecord{
		TerritoryName:                row[0],
		CountryOrRegion:              row[1],
		TerritoryType:                row[2],
		EducationAccess:              values[0],
		HealthAccess:                 values[1],
		IncomeSecurity:               values[2],
		PublicGoodsAccess:            values[3],
		OpportunityBlockage:          values[4],
		RiskExposure:                 values[5],
		InstitutionalCapture:         values[6],
		GovernanceCapacity:           values[7],
		InclusiveTransitionReadiness: values[8],
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

func inclusionRiskScore(record InclusionRecord) float64 {
	inclusiveCapability := 0.22*record.EducationAccess +
		0.22*record.HealthAccess +
		0.18*record.IncomeSecurity +
		0.20*record.PublicGoodsAccess +
		0.18*record.GovernanceCapacity

	exclusionaryInequality := 0.24*record.OpportunityBlockage +
		0.22*record.RiskExposure +
		0.22*record.InstitutionalCapture +
		0.16*(1-record.IncomeSecurity) +
		0.16*(1-record.PublicGoodsAccess)

	governance := 0.55*record.GovernanceCapacity +
		0.45*record.InclusiveTransitionReadiness

	score := 0.40*exclusionaryInequality +
		0.25*(1-inclusiveCapability) +
		0.20*record.InstitutionalCapture +
		0.15*(1-governance)

	return clamp01(score)
}

func main() {
	file, err := os.Open("inequality_inclusive_development_panel.csv")
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

		score := inclusionRiskScore(record)
		fmt.Printf(
			"territory_name=%s territory_type=%s inclusive_development_risk_score=%.3f\n",
			record.TerritoryName, record.TerritoryType, score,
		)
	}
}
