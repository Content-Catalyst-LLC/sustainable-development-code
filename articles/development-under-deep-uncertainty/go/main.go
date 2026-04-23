package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

type PathwayRecord struct {
	StrategyName     string
	ScenarioName     string
	PerformanceScore float64
	CostScore        float64
	AdaptabilityScore float64
	EquityScore      float64
}

func parseRecord(row []string) (PathwayRecord, error) {
	if len(row) != 6 {
		return PathwayRecord{}, fmt.Errorf("invalid record length")
	}

	performance, err := strconv.ParseFloat(row[2], 64)
	if err != nil {
		return PathwayRecord{}, err
	}

	cost, err := strconv.ParseFloat(row[3], 64)
	if err != nil {
		return PathwayRecord{}, err
	}

	adaptability, err := strconv.ParseFloat(row[4], 64)
	if err != nil {
		return PathwayRecord{}, err
	}

	equity, err := strconv.ParseFloat(row[5], 64)
	if err != nil {
		return PathwayRecord{}, err
	}

	return PathwayRecord{
		StrategyName:      row[0],
		ScenarioName:      row[1],
		PerformanceScore:  performance,
		CostScore:         cost,
		AdaptabilityScore: adaptability,
		EquityScore:       equity,
	}, nil
}

func outOfRange(value float64) bool {
	return value < 0.0 || value > 1.0
}

func compositeRobustness(record PathwayRecord) float64 {
	return 0.40*record.PerformanceScore +
		0.20*record.AdaptabilityScore +
		0.20*record.EquityScore +
		0.20*(1.0-record.CostScore)
}

func main() {
	file, err := os.Open("development_pathway_scenarios.csv")
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

		if outOfRange(record.PerformanceScore) ||
			outOfRange(record.CostScore) ||
			outOfRange(record.AdaptabilityScore) ||
			outOfRange(record.EquityScore) {
			fmt.Printf("INVALID: strategy=%s scenario=%s\n", record.StrategyName, record.ScenarioName)
			continue
		}

		score := compositeRobustness(record)
		fmt.Printf("VALID: strategy=%s scenario=%s composite_robustness=%.3f\n",
			record.StrategyName, record.ScenarioName, score)
	}
}
