package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

type AerosolRecord struct {
	TerritoryName               string
	CountryOrRegion             string
	TerritoryType               string
	AmbientPM25                 float64
	AmbientPM10                 float64
	HouseholdEnergyExposure     float64
	TransportEmissionsPressure  float64
	IndustrialSourcePressure    float64
	HealthSensitivity           float64
	MitigationCapacity          float64
	ExposureInequality          float64
	MonitoringReadiness         float64
}

func parseRecord(row []string) (AerosolRecord, error) {
	if len(row) != 12 {
		return AerosolRecord{}, fmt.Errorf("invalid record length")
	}

	values := make([]float64, 9)
	for i, col := range row[3:] {
		value, err := strconv.ParseFloat(col, 64)
		if err != nil {
			return AerosolRecord{}, err
		}
		values[i] = value
	}

	return AerosolRecord{
		TerritoryName:              row[0],
		CountryOrRegion:            row[1],
		TerritoryType:              row[2],
		AmbientPM25:                values[0],
		AmbientPM10:                values[1],
		HouseholdEnergyExposure:    values[2],
		TransportEmissionsPressure: values[3],
		IndustrialSourcePressure:   values[4],
		HealthSensitivity:          values[5],
		MitigationCapacity:         values[6],
		ExposureInequality:         values[7],
		MonitoringReadiness:        values[8],
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

func constrainedAerosolBurdenScore(record AerosolRecord) float64 {
	exposure := 0.28*record.AmbientPM25 +
		0.18*record.AmbientPM10 +
		0.18*record.HouseholdEnergyExposure +
		0.18*record.TransportEmissionsPressure +
		0.18*record.IndustrialSourcePressure

	vulnerability := 0.45*record.HealthSensitivity +
		0.35*record.ExposureInequality +
		0.20*(1-record.MitigationCapacity)

	governance := 0.55*record.MitigationCapacity +
		0.45*record.MonitoringReadiness

	score := 0.45*exposure +
		0.30*vulnerability +
		0.15*record.ExposureInequality +
		0.10*(1-governance)

	return clamp01(score)
}

func main() {
	file, err := os.Open("aerosols_air_quality_panel.csv")
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

		score := constrainedAerosolBurdenScore(record)
		fmt.Printf(
			"territory_name=%s territory_type=%s constrained_aerosol_burden_score=%.3f\n",
			record.TerritoryName, record.TerritoryType, score,
		)
	}
}
