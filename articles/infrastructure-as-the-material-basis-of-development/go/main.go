package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

type InfrastructureRecord struct {
	Country                    string
	Region                     string
	TerritoryType              string
	TransportAccessIndex       float64
	WaterAccessIndex           float64
	SanitationAccessIndex      float64
	ElectricityAccessIndex     float64
	DigitalConnectivityIndex   float64
	PublicServiceReachIndex    float64
	ReliabilityIndex           float64
	MaintenanceCapacityIndex   float64
	TerritorialEquityIndex     float64
	ClimateResilienceIndex     float64
	LockInRiskIndex            float64
}

func parseRecord(row []string) (InfrastructureRecord, error) {
	if len(row) != 14 {
		return InfrastructureRecord{}, fmt.Errorf("invalid record length")
	}

	values := make([]float64, 11)
	for i, col := range row[3:] {
		value, err := strconv.ParseFloat(col, 64)
		if err != nil {
			return InfrastructureRecord{}, err
		}
		values[i] = value
	}

	return InfrastructureRecord{
		Country:                  row[0],
		Region:                   row[1],
		TerritoryType:            row[2],
		TransportAccessIndex:     values[0],
		WaterAccessIndex:         values[1],
		SanitationAccessIndex:    values[2],
		ElectricityAccessIndex:   values[3],
		DigitalConnectivityIndex: values[4],
		PublicServiceReachIndex:  values[5],
		ReliabilityIndex:         values[6],
		MaintenanceCapacityIndex: values[7],
		TerritorialEquityIndex:   values[8],
		ClimateResilienceIndex:   values[9],
		LockInRiskIndex:          values[10],
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

func constrainedInfrastructureScore(record InfrastructureRecord) float64 {
	access := 0.18*record.TransportAccessIndex +
		0.18*record.WaterAccessIndex +
		0.14*record.SanitationAccessIndex +
		0.18*record.ElectricityAccessIndex +
		0.14*record.DigitalConnectivityIndex +
		0.18*record.TerritorialEquityIndex

	capability := 0.30*record.PublicServiceReachIndex +
		0.25*record.ReliabilityIndex +
		0.25*record.MaintenanceCapacityIndex +
		0.20*access

	resilience := 0.40*record.ClimateResilienceIndex +
		0.30*record.ReliabilityIndex +
		0.30*record.MaintenanceCapacityIndex

	score := 0.35*access +
		0.30*capability +
		0.25*resilience +
		0.10*(1-record.LockInRiskIndex)

	return clamp01(score)
}

func main() {
	file, err := os.Open("infrastructure_access_capability_panel.csv")
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

		score := constrainedInfrastructureScore(record)
		fmt.Printf(
			"country=%s territory_type=%s constrained_infrastructure_score=%.3f\n",
			record.Country, record.TerritoryType, score,
		)
	}
}
