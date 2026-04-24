package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

type PolicyCoherenceRecord struct {
	TerritoryName            string
	CountryOrRegion          string
	TerritoryType            string
	TradeoffIntensity        float64
	SynergyRealization       float64
	SectoralSpillover        float64
	TransboundarySpillover   float64
	IntergenerationalSpillover float64
	CoordinationCapacity     float64
	ImpactAssessment         float64
	MonitoringReview         float64
	SequencingCapacity       float64
	GovernanceFragmentation  float64
	PolicyAlignment          float64
}

func parseRecord(row []string) (PolicyCoherenceRecord, error) {
	if len(row) != 14 {
		return PolicyCoherenceRecord{}, fmt.Errorf("invalid record length")
	}

	values := make([]float64, 11)
	for i, col := range row[3:] {
		value, err := strconv.ParseFloat(col, 64)
		if err != nil {
			return PolicyCoherenceRecord{}, err
		}
		values[i] = value
	}

	return PolicyCoherenceRecord{
		TerritoryName:              row[0],
		CountryOrRegion:            row[1],
		TerritoryType:              row[2],
		TradeoffIntensity:          values[0],
		SynergyRealization:         values[1],
		SectoralSpillover:          values[2],
		TransboundarySpillover:     values[3],
		IntergenerationalSpillover: values[4],
		CoordinationCapacity:       values[5],
		ImpactAssessment:           values[6],
		MonitoringReview:           values[7],
		SequencingCapacity:         values[8],
		GovernanceFragmentation:    values[9],
		PolicyAlignment:            values[10],
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

func policyCoherenceRiskScore(record PolicyCoherenceRecord) float64 {
	policyInteractionPressure := 0.20*record.TradeoffIntensity +
		0.16*record.SectoralSpillover +
		0.14*record.TransboundarySpillover +
		0.14*record.IntergenerationalSpillover +
		0.18*record.GovernanceFragmentation +
		0.18*(1-record.PolicyAlignment)

	coherenceCapacity := 0.28*record.CoordinationCapacity +
		0.20*record.ImpactAssessment +
		0.18*record.MonitoringReview +
		0.18*record.SequencingCapacity +
		0.16*record.SynergyRealization

	score := 0.50*policyInteractionPressure +
		0.25*(1-coherenceCapacity) +
		0.15*record.GovernanceFragmentation +
		0.10*(1-record.PolicyAlignment)

	return clamp01(score)
}

func main() {
	file, err := os.Open("tradeoffs_synergies_policy_coherence_panel.csv")
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

		score := policyCoherenceRiskScore(record)
		fmt.Printf(
			"territory_name=%s territory_type=%s policy_coherence_risk_score=%.3f\n",
			record.TerritoryName, record.TerritoryType, score,
		)
	}
}
