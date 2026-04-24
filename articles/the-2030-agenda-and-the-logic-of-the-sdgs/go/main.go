package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

type SDGRecord struct {
	TerritoryName            string
	CountryOrRegion          string
	TerritoryType            string
	UniversalityExposure     float64
	IntegrationComplexity    float64
	ImplementationCapacity   float64
	MeansOfImplementation    float64
	PartnershipReadiness     float64
	MonitoringCapacity       float64
	IndicatorCoverage        float64
	ReviewResponsiveness     float64
	PolicyFragmentation      float64
	SDGAlignment             float64
}

func parseRecord(row []string) (SDGRecord, error) {
	if len(row) != 13 {
		return SDGRecord{}, fmt.Errorf("invalid record length")
	}

	values := make([]float64, 10)
	for i, col := range row[3:] {
		value, err := strconv.ParseFloat(col, 64)
		if err != nil {
			return SDGRecord{}, err
		}
		values[i] = value
	}

	return SDGRecord{
		TerritoryName:          row[0],
		CountryOrRegion:        row[1],
		TerritoryType:          row[2],
		UniversalityExposure:   values[0],
		IntegrationComplexity:  values[1],
		ImplementationCapacity: values[2],
		MeansOfImplementation:  values[3],
		PartnershipReadiness:   values[4],
		MonitoringCapacity:     values[5],
		IndicatorCoverage:      values[6],
		ReviewResponsiveness:   values[7],
		PolicyFragmentation:    values[8],
		SDGAlignment:           values[9],
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

func sdgGovernanceRiskScore(record SDGRecord) float64 {
	agendaPressure := 0.16*record.UniversalityExposure +
		0.16*record.IntegrationComplexity +
		0.14*(1-record.ImplementationCapacity) +
		0.14*(1-record.MeansOfImplementation) +
		0.12*(1-record.PartnershipReadiness) +
		0.12*(1-record.MonitoringCapacity) +
		0.08*(1-record.IndicatorCoverage) +
		0.08*record.PolicyFragmentation

	agendaCapacity := 0.28*record.ImplementationCapacity +
		0.22*record.MeansOfImplementation +
		0.18*record.PartnershipReadiness +
		0.16*record.MonitoringCapacity +
		0.08*record.IndicatorCoverage +
		0.08*record.ReviewResponsiveness

	score := 0.50*agendaPressure +
		0.30*(1-agendaCapacity) +
		0.20*record.PolicyFragmentation

	return clamp01(score)
}

func main() {
	file, err := os.Open("agenda_2030_sdg_logic_panel.csv")
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

		score := sdgGovernanceRiskScore(record)
		fmt.Printf(
			"territory_name=%s territory_type=%s sdg_governance_risk_score=%.3f\n",
			record.TerritoryName, record.TerritoryType, score,
		)
	}
}
