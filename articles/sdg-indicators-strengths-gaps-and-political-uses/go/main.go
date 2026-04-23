package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

type IndicatorRecord struct {
	Country       string
	Goal          string
	IndicatorCode string
	ActualValue   float64
	TargetValue   float64
	Direction     string
	LowerBound    float64
	UpperBound    float64
}

func parseRecord(row []string) (IndicatorRecord, error) {
	if len(row) < 9 {
		return IndicatorRecord{}, fmt.Errorf("invalid record length")
	}

	actual, err := strconv.ParseFloat(row[4], 64)
	if err != nil {
		return IndicatorRecord{}, err
	}

	target, err := strconv.ParseFloat(row[5], 64)
	if err != nil {
		return IndicatorRecord{}, err
	}

	lower, err := strconv.ParseFloat(row[7], 64)
	if err != nil {
		return IndicatorRecord{}, err
	}

	upper, err := strconv.ParseFloat(row[8], 64)
	if err != nil {
		return IndicatorRecord{}, err
	}

	return IndicatorRecord{
		Country:       row[0],
		Goal:          row[1],
		IndicatorCode: row[2],
		ActualValue:   actual,
		TargetValue:   target,
		Direction:     row[6],
		LowerBound:    lower,
		UpperBound:    upper,
	}, nil
}

func distanceToTarget(record IndicatorRecord) float64 {
	scale := record.UpperBound - record.LowerBound
	if scale <= 0 {
		return 1.0
	}

	if record.Direction == "higher_better" {
		if record.TargetValue > record.ActualValue {
			return (record.TargetValue - record.ActualValue) / scale
		}
		return 0.0
	}

	if record.ActualValue > record.TargetValue {
		return (record.ActualValue - record.TargetValue) / scale
	}
	return 0.0
}

func main() {
	file, err := os.Open("sdg_indicator_values.csv")
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

		distance := distanceToTarget(record)
		fmt.Printf(
			"country=%s goal=%s indicator=%s distance_to_target=%.3f\n",
			record.Country, record.Goal, record.IndicatorCode, distance,
		)
	}
}
