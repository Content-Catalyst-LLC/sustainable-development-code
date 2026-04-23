package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

type PlanetaryRecord struct {
	TerritoryName           string
	CountryOrRegion         string
	TerritoryType           string
	ClimateStress           float64
	BiosphereIntegrityLoss  float64
	FreshwaterChange        float64
	LandSystemChange        float64
	BiogeochemicalPressure  float64
	NovelEntitiesBurden     float64
	JusticeExposure         float64
	GovernanceCapacity      float64
	TransitionReadiness     float64
}

func parseRecord(row []string) (PlanetaryRecord, error) {
	if len(row) != 12 {
		return PlanetaryRecord{}, fmt.Errorf("invalid record length")
	}

	values := make([]float64, 9)
	for i, col := range row[3:] {
		value, err := strconv.ParseFloat(col, 64)
		if err != nil {
			return PlanetaryRecord{}, err
		}
		values[i] = value
	}

	return PlanetaryRecord{
		TerritoryName:          row[0],
		CountryOrRegion:        row[1],
		TerritoryType:          row[2],
		ClimateStress:          values[0],
		BiosphereIntegrityLoss: values[1],
		FreshwaterChange:       values[2],
		LandSystemChange:       values[3],
		BiogeochemicalPressure: values[4],
		NovelEntitiesBurden:    values[5],
		JusticeExposure:        values[6],
		GovernanceCapacity:     values[7],
		TransitionReadiness:    values[8],
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

func constrainedPlanetaryDevelopmentScore(record PlanetaryRecord) float64 {
	earthSystemStress := 0.18*record.ClimateStress +
		0.18*record.BiosphereIntegrityLoss +
		0.16*record.FreshwaterChange +
		0.16*record.LandSystemChange +
		0.16*record.BiogeochemicalPressure +
		0.16*record.NovelEntitiesBurden

	developmentExposure := 0.45*record.JusticeExposure +
		0.30*record.BiosphereIntegrityLoss +
		0.25*record.FreshwaterChange

	governance := 0.55*record.GovernanceCapacity +
		0.45*record.TransitionReadiness

	score := 0.42*earthSystemStress +
		0.28*developmentExposure +
		0.15*record.JusticeExposure +
		0.15*(1-governance)

	return clamp01(score)
}

func main() {
	file, err := os.Open("planetary_boundaries_panel.csv")
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

		score := constrainedPlanetaryDevelopmentScore(record)
		fmt.Printf(
			"territory_name=%s territory_type=%s constrained_planetary_development_score=%.3f\n",
			record.TerritoryName, record.TerritoryType, score,
		)
	}
}
