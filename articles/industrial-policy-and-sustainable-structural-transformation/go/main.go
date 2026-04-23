package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

type SectorRecord struct {
	Country                      string
	Region                       string
	Sector                       string
	ManufacturingValueAddedIndex float64
	ServicesProductivityIndex    float64
	ExportComplexityIndex        float64
	TechnologyUpgradingIndex     float64
	SkillsDepthIndex             float64
	InfrastructureQualityIndex   float64
	SupplierEcosystemIndex       float64
	GreenTransitionReadiness     float64
	RegionalInclusionIndex       float64
	InstitutionalCoordination    float64
	LockInRiskIndex              float64
}

func parseRecord(row []string) (SectorRecord, error) {
	if len(row) != 14 {
		return SectorRecord{}, fmt.Errorf("invalid record length")
	}

	values := make([]float64, 11)
	for i, col := range row[3:] {
		value, err := strconv.ParseFloat(col, 64)
		if err != nil {
			return SectorRecord{}, err
		}
		values[i] = value
	}

	return SectorRecord{
		Country:                      row[0],
		Region:                       row[1],
		Sector:                       row[2],
		ManufacturingValueAddedIndex: values[0],
		ServicesProductivityIndex:    values[1],
		ExportComplexityIndex:        values[2],
		TechnologyUpgradingIndex:     values[3],
		SkillsDepthIndex:             values[4],
		InfrastructureQualityIndex:   values[5],
		SupplierEcosystemIndex:       values[6],
		GreenTransitionReadiness:     values[7],
		RegionalInclusionIndex:       values[8],
		InstitutionalCoordination:    values[9],
		LockInRiskIndex:              values[10],
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

func constrainedTransition(record SectorRecord) float64 {
	productiveCapability := 0.20*record.TechnologyUpgradingIndex +
		0.18*record.SkillsDepthIndex +
		0.17*record.SupplierEcosystemIndex +
		0.15*record.InfrastructureQualityIndex +
		0.15*record.InstitutionalCoordination +
		0.15*record.ExportComplexityIndex

	structuralTransformation := 0.22*record.ManufacturingValueAddedIndex +
		0.15*record.ServicesProductivityIndex +
		0.18*productiveCapability +
		0.15*record.RegionalInclusionIndex +
		0.15*record.SupplierEcosystemIndex +
		0.15*record.TechnologyUpgradingIndex

	greenAlignment := 0.35*record.GreenTransitionReadiness +
		0.25*record.TechnologyUpgradingIndex +
		0.20*record.InfrastructureQualityIndex +
		0.20*record.InstitutionalCoordination

	score := 0.45*structuralTransformation +
		0.25*productiveCapability +
		0.20*greenAlignment +
		0.10*(1-record.LockInRiskIndex)

	return clamp01(score)
}

func main() {
	file, err := os.Open("industrial_transformation_panel.csv")
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

		score := constrainedTransition(record)
		fmt.Printf(
			"country=%s sector=%s constrained_transition_score=%.3f\n",
			record.Country, record.Sector, score,
		)
	}
}
