package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

type HumanDevelopmentRecord struct {
	TerritoryName             string
	CountryOrRegion           string
	TerritoryType             string
	OutputGrowth              float64
	HealthCapability          float64
	EducationCapability       float64
	IncomeConversion          float64
	PublicGoodsConversion     float64
	DistributionConstraint    float64
	InstitutionalSupport      float64
	EcologicalDurability      float64
	AgencyFreedom             float64
	HumanDevelopmentAlignment float64
}

func parseRecord(row []string) (HumanDevelopmentRecord, error) {
	if len(row) != 13 {
		return HumanDevelopmentRecord{}, fmt.Errorf("invalid record length")
	}

	values := make([]float64, 10)
	for i, col := range row[3:] {
		value, err := strconv.ParseFloat(col, 64)
		if err != nil {
			return HumanDevelopmentRecord{}, err
		}
		values[i] = value
	}

	return HumanDevelopmentRecord{
		TerritoryName:             row[0],
		CountryOrRegion:           row[1],
		TerritoryType:             row[2],
		OutputGrowth:              values[0],
		HealthCapability:          values[1],
		EducationCapability:       values[2],
		IncomeConversion:          values[3],
		PublicGoodsConversion:     values[4],
		DistributionConstraint:    values[5],
		InstitutionalSupport:      values[6],
		EcologicalDurability:      values[7],
		AgencyFreedom:             values[8],
		HumanDevelopmentAlignment: values[9],
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

func humanDevelopmentRiskScore(record HumanDevelopmentRecord) float64 {
	growthTranslationPressure := 0.16*record.OutputGrowth +
		0.14*(1-record.IncomeConversion) +
		0.14*(1-record.PublicGoodsConversion) +
		0.14*record.DistributionConstraint +
		0.12*(1-record.InstitutionalSupport) +
		0.12*(1-record.EcologicalDurability) +
		0.10*(1-record.AgencyFreedom) +
		0.08*(1-record.HumanDevelopmentAlignment)

	capabilityExpansion := 0.22*record.HealthCapability +
		0.22*record.EducationCapability +
		0.18*record.IncomeConversion +
		0.16*record.PublicGoodsConversion +
		0.12*record.AgencyFreedom +
		0.10*record.HumanDevelopmentAlignment

	score := 0.50*growthTranslationPressure +
		0.30*(1-capabilityExpansion) +
		0.20*record.DistributionConstraint

	return clamp01(score)
}

func main() {
	file, err := os.Open("economic_growth_to_human_development_panel.csv")
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

		score := humanDevelopmentRiskScore(record)
		fmt.Printf(
			"territory_name=%s territory_type=%s human_development_risk_score=%.3f\n",
			record.TerritoryName, record.TerritoryType, score,
		)
	}
}
