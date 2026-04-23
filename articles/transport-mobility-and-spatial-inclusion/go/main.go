package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

type MobilityRecord struct {
	CityRegion                  string
	Country                     string
	TerritoryType               string
	PublicTransportCoverage     float64
	JobsAccessIndex             float64
	EducationAccessIndex        float64
	HealthcareAccessIndex       float64
	FareAffordabilityIndex      float64
	TravelTimeBurdenIndex       float64
	SafetyIndex                 float64
	WalkabilityIndex            float64
	UniversalAccessIndex        float64
	MultimodalIntegrationIndex  float64
	CarDependenceRiskIndex      float64
	ClimateAlignmentIndex       float64
}

func parseRecord(row []string) (MobilityRecord, error) {
	if len(row) != 15 {
		return MobilityRecord{}, fmt.Errorf("invalid record length")
	}

	values := make([]float64, 12)
	for i, col := range row[3:] {
		value, err := strconv.ParseFloat(col, 64)
		if err != nil {
			return MobilityRecord{}, err
		}
		values[i] = value
	}

	return MobilityRecord{
		CityRegion:                 row[0],
		Country:                    row[1],
		TerritoryType:              row[2],
		PublicTransportCoverage:    values[0],
		JobsAccessIndex:            values[1],
		EducationAccessIndex:       values[2],
		HealthcareAccessIndex:      values[3],
		FareAffordabilityIndex:     values[4],
		TravelTimeBurdenIndex:      values[5],
		SafetyIndex:                values[6],
		WalkabilityIndex:           values[7],
		UniversalAccessIndex:       values[8],
		MultimodalIntegrationIndex: values[9],
		CarDependenceRiskIndex:     values[10],
		ClimateAlignmentIndex:      values[11],
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

func constrainedSpatialInclusion(record MobilityRecord) float64 {
	accessibility := 0.20*record.JobsAccessIndex +
		0.20*record.EducationAccessIndex +
		0.20*record.HealthcareAccessIndex +
		0.15*record.PublicTransportCoverage +
		0.10*record.WalkabilityIndex +
		0.15*record.MultimodalIntegrationIndex

	everydayInclusion := 0.20*record.FareAffordabilityIndex +
		0.20*(1-record.TravelTimeBurdenIndex) +
		0.20*record.SafetyIndex +
		0.20*record.UniversalAccessIndex +
		0.20*record.PublicTransportCoverage

	sustainableAlignment := 0.30*record.ClimateAlignmentIndex +
		0.25*record.WalkabilityIndex +
		0.20*record.MultimodalIntegrationIndex +
		0.25*(1-record.CarDependenceRiskIndex)

	score := 0.40*accessibility +
		0.30*everydayInclusion +
		0.20*sustainableAlignment +
		0.10*(1-record.CarDependenceRiskIndex)

	return clamp01(score)
}

func main() {
	file, err := os.Open("mobility_accessibility_panel.csv")
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

		score := constrainedSpatialInclusion(record)
		fmt.Printf(
			"city_region=%s territory_type=%s constrained_spatial_inclusion_score=%.3f\n",
			record.CityRegion, record.TerritoryType, score,
		)
	}
}
