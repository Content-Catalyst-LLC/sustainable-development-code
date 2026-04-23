package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

type LocalRecord struct {
	CityOrRegion                    string
	Country                         string
	TerritoryType                   string
	ServiceReach                    float64
	LandHousingCoordination         float64
	InfrastructureMobilityIntegration float64
	ResilienceCapacity              float64
	SpatialJustice                  float64
	ParticipatoryLocalGovernance    float64
	MultilevelAlignment             float64
	DataLearningCapacity            float64
	FragmentationRisk               float64
}

func parseRecord(row []string) (LocalRecord, error) {
	if len(row) != 12 {
		return LocalRecord{}, fmt.Errorf("invalid record length")
	}

	values := make([]float64, 9)
	for i, col := range row[3:] {
		value, err := strconv.ParseFloat(col, 64)
		if err != nil {
			return LocalRecord{}, err
		}
		values[i] = value
	}

	return LocalRecord{
		CityOrRegion:                    row[0],
		Country:                         row[1],
		TerritoryType:                   row[2],
		ServiceReach:                    values[0],
		LandHousingCoordination:         values[1],
		InfrastructureMobilityIntegration: values[2],
		ResilienceCapacity:              values[3],
		SpatialJustice:                  values[4],
		ParticipatoryLocalGovernance:    values[5],
		MultilevelAlignment:             values[6],
		DataLearningCapacity:            values[7],
		FragmentationRisk:               values[8],
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

func constrainedLocalGovernanceScore(record LocalRecord) float64 {
	territorialCapacity := 0.18*record.ServiceReach +
		0.16*record.LandHousingCoordination +
		0.16*record.InfrastructureMobilityIntegration +
		0.16*record.ResilienceCapacity +
		0.14*record.SpatialJustice +
		0.10*record.ParticipatoryLocalGovernance +
		0.10*record.MultilevelAlignment

	localLearning := 0.40*record.DataLearningCapacity +
		0.30*record.MultilevelAlignment +
		0.30*record.ParticipatoryLocalGovernance

	score := 0.60*territorialCapacity +
		0.20*localLearning +
		0.10*record.ResilienceCapacity +
		0.10*(1-record.FragmentationRisk)

	return clamp01(score)
}

func main() {
	file, err := os.Open("local_governance_territorial_panel.csv")
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

		score := constrainedLocalGovernanceScore(record)
		fmt.Printf(
			"city_or_region=%s territory_type=%s constrained_local_governance_score=%.3f\n",
			record.CityOrRegion, record.TerritoryType, score,
		)
	}
}
