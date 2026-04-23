package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

type GovernanceRecord struct {
	CountryOrRegime          string
	Region                   string
	GovernanceDomain         string
	CoordinationStrength     float64
	FinancingSupport         float64
	KnowledgeStandards       float64
	ImplementationSupport    float64
	Legitimacy               float64
	ResilienceCoordination   float64
	FragmentationRisk        float64
	UnequalInfluenceRisk     float64
	InstitutionalLockinRisk  float64
}

func parseRecord(row []string) (GovernanceRecord, error) {
	if len(row) != 12 {
		return GovernanceRecord{}, fmt.Errorf("invalid record length")
	}

	values := make([]float64, 9)
	for i, col := range row[3:] {
		value, err := strconv.ParseFloat(col, 64)
		if err != nil {
			return GovernanceRecord{}, err
		}
		values[i] = value
	}

	return GovernanceRecord{
		CountryOrRegime:         row[0],
		Region:                  row[1],
		GovernanceDomain:        row[2],
		CoordinationStrength:    values[0],
		FinancingSupport:        values[1],
		KnowledgeStandards:      values[2],
		ImplementationSupport:   values[3],
		Legitimacy:              values[4],
		ResilienceCoordination:  values[5],
		FragmentationRisk:       values[6],
		UnequalInfluenceRisk:    values[7],
		InstitutionalLockinRisk: values[8],
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

func constrainedGlobalGovernanceScore(record GovernanceRecord) float64 {
	capacity := 0.22*record.CoordinationStrength +
		0.18*record.FinancingSupport +
		0.18*record.KnowledgeStandards +
		0.16*record.ImplementationSupport +
		0.14*record.Legitimacy +
		0.12*record.ResilienceCoordination

	friction := 0.40*record.FragmentationRisk +
		0.30*record.UnequalInfluenceRisk +
		0.30*record.InstitutionalLockinRisk

	score := 0.65*capacity +
		0.15*record.Legitimacy +
		0.10*record.ImplementationSupport +
		0.10*(1-friction)

	return clamp01(score)
}

func main() {
	file, err := os.Open("global_development_governance_panel.csv")
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

		score := constrainedGlobalGovernanceScore(record)
		fmt.Printf(
			"country_or_regime=%s governance_domain=%s constrained_global_governance_score=%.3f\n",
			record.CountryOrRegime, record.GovernanceDomain, score,
		)
	}
}
