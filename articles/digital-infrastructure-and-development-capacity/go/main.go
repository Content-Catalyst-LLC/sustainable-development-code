package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

type CapacityRecord struct {
	Country                    string
	Region                     string
	Sector                     string
	ConnectivityIndex          float64
	DigitalIdentityIndex       float64
	PaymentsRailIndex          float64
	DataExchangeIndex          float64
	RegistryIntegrityIndex     float64
	ServiceDeliveryIndex       float64
	CybersecurityIndex         float64
	PublicTrustIndex           float64
	InclusionAccessIndex       float64
	ComputeCloudIndex          float64
	InteroperabilityIndex      float64
	InstitutionalUseCapacity   float64
	LockInRiskIndex            float64
}

func parseRecord(row []string) (CapacityRecord, error) {
	if len(row) != 16 {
		return CapacityRecord{}, fmt.Errorf("invalid record length")
	}

	values := make([]float64, 13)
	for i, col := range row[3:] {
		value, err := strconv.ParseFloat(col, 64)
		if err != nil {
			return CapacityRecord{}, err
		}
		values[i] = value
	}

	return CapacityRecord{
		Country:                  row[0],
		Region:                   row[1],
		Sector:                   row[2],
		ConnectivityIndex:        values[0],
		DigitalIdentityIndex:     values[1],
		PaymentsRailIndex:        values[2],
		DataExchangeIndex:        values[3],
		RegistryIntegrityIndex:   values[4],
		ServiceDeliveryIndex:     values[5],
		CybersecurityIndex:       values[6],
		PublicTrustIndex:         values[7],
		InclusionAccessIndex:     values[8],
		ComputeCloudIndex:        values[9],
		InteroperabilityIndex:    values[10],
		InstitutionalUseCapacity: values[11],
		LockInRiskIndex:          values[12],
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

func digitalCapacityScore(record CapacityRecord) float64 {
	foundational := 0.25*record.ConnectivityIndex +
		0.15*record.ComputeCloudIndex +
		0.15*record.CybersecurityIndex +
		0.15*record.RegistryIntegrityIndex +
		0.15*record.InteroperabilityIndex +
		0.15*record.InclusionAccessIndex

	dpi := 0.20*record.DigitalIdentityIndex +
		0.20*record.PaymentsRailIndex +
		0.20*record.DataExchangeIndex +
		0.15*record.RegistryIntegrityIndex +
		0.15*record.InteroperabilityIndex +
		0.10*record.CybersecurityIndex

	service := 0.30*record.ServiceDeliveryIndex +
		0.20*record.InstitutionalUseCapacity +
		0.15*record.PublicTrustIndex +
		0.15*record.InclusionAccessIndex +
		0.10*dpi +
		0.10*foundational

	score := 0.35*foundational +
		0.30*dpi +
		0.25*service +
		0.10*(1-record.LockInRiskIndex)

	return clamp01(score)
}

func main() {
	file, err := os.Open("digital_infrastructure_capacity_panel.csv")
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

		score := digitalCapacityScore(record)
		fmt.Printf(
			"country=%s sector=%s constrained_digital_capacity_score=%.3f\n",
			record.Country, record.Sector, score,
		)
	}
}
