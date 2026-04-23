package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

type ResilienceRecord struct {
	SystemName                string
	Region                    string
	DisturbanceExposureIndex  float64
	CopingCapacityIndex       float64
	AdaptiveCapacityIndex     float64
	TransformativeCapacityIndex float64
	InstitutionalLearningIndex float64
	EcologicalBufferIndex     float64
	EquityProtectionIndex     float64
}

func parseRecord(row []string) (ResilienceRecord, error) {
	if len(row) != 9 {
		return ResilienceRecord{}, fmt.Errorf("invalid record length")
	}

	values := make([]float64, 7)
	for i, col := range row[2:] {
		value, err := strconv.ParseFloat(col, 64)
		if err != nil {
			return ResilienceRecord{}, err
		}
		values[i] = value
	}

	return ResilienceRecord{
		SystemName:                  row[0],
		Region:                      row[1],
		DisturbanceExposureIndex:    values[0],
		CopingCapacityIndex:         values[1],
		AdaptiveCapacityIndex:       values[2],
		TransformativeCapacityIndex: values[3],
		InstitutionalLearningIndex:  values[4],
		EcologicalBufferIndex:       values[5],
		EquityProtectionIndex:       values[6],
	}, nil
}

func resilienceScore(record ResilienceRecord) float64 {
	return 0.20*record.CopingCapacityIndex +
		0.20*record.AdaptiveCapacityIndex +
		0.20*record.TransformativeCapacityIndex +
		0.15*record.InstitutionalLearningIndex +
		0.15*record.EcologicalBufferIndex +
		0.10*record.EquityProtectionIndex
}

func main() {
	file, err := os.Open("resilience_system_data.csv")
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

		score := resilienceScore(record)
		fmt.Printf("system=%s region=%s resilience_score=%.3f\n",
			record.SystemName, record.Region, score)
	}
}
