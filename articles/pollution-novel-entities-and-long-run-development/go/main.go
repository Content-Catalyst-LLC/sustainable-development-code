package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

type PollutionRecord struct {
	TerritoryName                string
	CountryOrRegion              string
	TerritoryType                string
	HazardousMaterialThroughput  float64
	WasteSystemOverload          float64
	PersistenceMobilityRisk      float64
	AssessmentLag                float64
	ExposureInequality           float64
	GovernanceCapacity           float64
	RemediationReadiness         float64
	EcosystemToxicity            float64
	PublicHealthBurden           float64
}

func parseRecord(row []string) (PollutionRecord, error) {
	if len(row) != 12 {
		return PollutionRecord{}, fmt.Errorf("invalid record length")
	}

	values := make([]float64, 9)
	for i, col := range row[3:] {
		value, err := strconv.ParseFloat(col, 64)
		if err != nil {
			return PollutionRecord{}, err
		}
		values[i] = value
	}

	return PollutionRecord{
		TerritoryName:               row[0],
		CountryOrRegion:             row[1],
		TerritoryType:               row[2],
		HazardousMaterialThroughput: values[0],
		WasteSystemOverload:         values[1],
		PersistenceMobilityRisk:     values[2],
		AssessmentLag:               values[3],
		ExposureInequality:          values[4],
		GovernanceCapacity:          values[5],
		RemediationReadiness:        values[6],
		EcosystemToxicity:           values[7],
		PublicHealthBurden:          values[8],
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

func constrainedPollutionDevelopmentScore(record PollutionRecord) float64 {
	materialRisk := 0.24*record.HazardousMaterialThroughput +
		0.18*record.WasteSystemOverload +
		0.22*record.PersistenceMobilityRisk +
		0.18*record.EcosystemToxicity +
		0.18*record.PublicHealthBurden

	novelEntitiesPressure := 0.45*record.AssessmentLag +
		0.30*record.PersistenceMobilityRisk +
		0.25*record.HazardousMaterialThroughput

	governance := 0.55*record.GovernanceCapacity +
		0.45*record.RemediationReadiness

	score := 0.40*materialRisk +
		0.25*novelEntitiesPressure +
		0.20*record.ExposureInequality +
		0.15*(1-governance)

	return clamp01(score)
}

func main() {
	file, err := os.Open("pollution_novel_entities_panel.csv")
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

		score := constrainedPollutionDevelopmentScore(record)
		fmt.Printf(
			"territory_name=%s territory_type=%s constrained_pollution_development_score=%.3f\n",
			record.TerritoryName, record.TerritoryType, score,
		)
	}
}
