package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

type ProjectRecord struct {
	ProjectID                     string
	Country                       string
	Region                        string
	Sector                        string
	ProjectSizeUSD                float64
	DevelopmentNeedIndex          float64
	ClimateResilienceIndex        float64
	InclusionIndex                float64
	BankabilityIndex              float64
	PolicyAlignmentIndex          float64
	BlendedFinancePotentialIndex  float64
	DebtSpaceConstraintIndex      float64
	ImplementationCapacityIndex   float64
	TaxonomyAlignmentIndex        float64
}

func parseRecord(row []string) (ProjectRecord, error) {
	if len(row) != 14 {
		return ProjectRecord{}, fmt.Errorf("invalid record length")
	}

	projectSize, err := strconv.ParseFloat(row[4], 64)
	if err != nil {
		return ProjectRecord{}, err
	}

	values := make([]float64, 9)
	for i, col := range row[5:] {
		value, err := strconv.ParseFloat(col, 64)
		if err != nil {
			return ProjectRecord{}, err
		}
		values[i] = value
	}

	return ProjectRecord{
		ProjectID:                    row[0],
		Country:                      row[1],
		Region:                       row[2],
		Sector:                       row[3],
		ProjectSizeUSD:               projectSize,
		DevelopmentNeedIndex:         values[0],
		ClimateResilienceIndex:       values[1],
		InclusionIndex:               values[2],
		BankabilityIndex:             values[3],
		PolicyAlignmentIndex:         values[4],
		BlendedFinancePotentialIndex: values[5],
		DebtSpaceConstraintIndex:     values[6],
		ImplementationCapacityIndex:  values[7],
		TaxonomyAlignmentIndex:       values[8],
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

func constrainedPriority(record ProjectRecord) float64 {
	developmentAdditionality := 0.35*record.DevelopmentNeedIndex +
		0.25*record.ClimateResilienceIndex +
		0.20*record.InclusionIndex +
		0.20*record.PolicyAlignmentIndex

	implementationFeasibility := 0.45*record.ImplementationCapacityIndex +
		0.30*record.BankabilityIndex +
		0.25*record.TaxonomyAlignmentIndex

	financeability := 0.40*record.BankabilityIndex +
		0.25*record.BlendedFinancePotentialIndex +
		0.20*record.TaxonomyAlignmentIndex +
		0.15*(1-record.DebtSpaceConstraintIndex)

	score := 0.45*developmentAdditionality +
		0.25*implementationFeasibility +
		0.20*financeability +
		0.10*(1-record.DebtSpaceConstraintIndex)

	return clamp01(score)
}

func main() {
	file, err := os.Open("sustainable_finance_project_pipeline.csv")
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

		score := constrainedPriority(record)
		fmt.Printf(
			"project_id=%s country=%s sector=%s constrained_priority_score=%.3f\n",
			record.ProjectID, record.Country, record.Sector, score,
		)
	}
}
