package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

type LawRecord struct {
	Country                       string
	Region                        string
	LegalDomain                   string
	RightsProtection              float64
	AccessToJustice               float64
	ProceduralParticipation       float64
	EnvironmentalRightsIntegration float64
	AccountabilityStructure       float64
	NonDiscriminationProtection   float64
	AdministrativeReview          float64
	EnforcementCapacity           float64
	LegalExclusionRisk            float64
}

func parseRecord(row []string) (LawRecord, error) {
	if len(row) != 12 {
		return LawRecord{}, fmt.Errorf("invalid record length")
	}

	values := make([]float64, 9)
	for i, col := range row[3:] {
		value, err := strconv.ParseFloat(col, 64)
		if err != nil {
			return LawRecord{}, err
		}
		values[i] = value
	}

	return LawRecord{
		Country:                        row[0],
		Region:                         row[1],
		LegalDomain:                    row[2],
		RightsProtection:               values[0],
		AccessToJustice:                values[1],
		ProceduralParticipation:        values[2],
		EnvironmentalRightsIntegration: values[3],
		AccountabilityStructure:        values[4],
		NonDiscriminationProtection:    values[5],
		AdministrativeReview:           values[6],
		EnforcementCapacity:            values[7],
		LegalExclusionRisk:             values[8],
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

func constrainedLegalDevelopmentScore(record LawRecord) float64 {
	legalProtection := 0.22*record.RightsProtection +
		0.18*record.NonDiscriminationProtection +
		0.15*record.EnvironmentalRightsIntegration +
		0.15*record.ProceduralParticipation +
		0.15*record.AccountabilityStructure +
		0.15*record.AdministrativeReview

	remedyCapacity := 0.35*record.AccessToJustice +
		0.25*record.AdministrativeReview +
		0.20*record.EnforcementCapacity +
		0.20*record.AccountabilityStructure

	score := 0.45*legalProtection +
		0.30*remedyCapacity +
		0.15*record.EnvironmentalRightsIntegration +
		0.10*(1-record.LegalExclusionRisk)

	return clamp01(score)
}

func main() {
	file, err := os.Open("law_rights_development_panel.csv")
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

		score := constrainedLegalDevelopmentScore(record)
		fmt.Printf(
			"country=%s legal_domain=%s constrained_legal_development_score=%.3f\n",
			record.Country, record.LegalDomain, score,
		)
	}
}
