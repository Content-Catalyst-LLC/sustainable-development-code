package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

type PolicyRecord struct {
	Country                    string
	Region                     string
	PolicyDomain               string
	CrossSectorAlignment       float64
	SpilloverManagement        float64
	TradeoffVisibility         float64
	SynergyCapture             float64
	ImplementationAlignment    float64
	MultilevelCoordination     float64
	DataVisibility             float64
	InstitutionalLearning      float64
	ResilienceIntegration      float64
	LockInRisk                 float64
}

func parseRecord(row []string) (PolicyRecord, error) {
	if len(row) != 13 {
		return PolicyRecord{}, fmt.Errorf("invalid record length")
	}

	values := make([]float64, 10)
	for i, col := range row[3:] {
		value, err := strconv.ParseFloat(col, 64)
		if err != nil {
			return PolicyRecord{}, err
		}
		values[i] = value
	}

	return PolicyRecord{
		Country:                 row[0],
		Region:                  row[1],
		PolicyDomain:            row[2],
		CrossSectorAlignment:    values[0],
		SpilloverManagement:     values[1],
		TradeoffVisibility:      values[2],
		SynergyCapture:          values[3],
		ImplementationAlignment: values[4],
		MultilevelCoordination:  values[5],
		DataVisibility:          values[6],
		InstitutionalLearning:   values[7],
		ResilienceIntegration:   values[8],
		LockInRisk:              values[9],
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

func constrainedSystemicGovernanceScore(record PolicyRecord) float64 {
	coherence := 0.25*record.CrossSectorAlignment +
		0.20*record.SpilloverManagement +
		0.15*record.TradeoffVisibility +
		0.15*record.SynergyCapture +
		0.15*record.ImplementationAlignment +
		0.10*record.MultilevelCoordination

	adaptive := 0.25*record.DataVisibility +
		0.25*record.InstitutionalLearning +
		0.20*record.SpilloverManagement +
		0.15*record.MultilevelCoordination +
		0.15*record.ImplementationAlignment

	transition := 0.35*record.ResilienceIntegration +
		0.25*coherence +
		0.20*adaptive +
		0.20*record.SynergyCapture

	score := 0.35*coherence +
		0.25*adaptive +
		0.25*transition +
		0.15*(1-record.LockInRisk)

	return clamp01(score)
}

func main() {
	file, err := os.Open("policy_coherence_panel.csv")
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

		score := constrainedSystemicGovernanceScore(record)
		fmt.Printf(
			"country=%s policy_domain=%s constrained_systemic_governance_score=%.3f\n",
			record.Country, record.PolicyDomain, score,
		)
	}
}
