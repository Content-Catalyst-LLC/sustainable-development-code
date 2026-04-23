package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

type DebtRecord struct {
	Country                    string
	Region                     string
	Year                       int
	PublicDebtGDPRatio         float64
	ExternalDebtExportRatio    float64
	DebtServiceRevenueRatio    float64
	InterestRevenueRatio       float64
	GrossFinancingNeedsGDP     float64
	AvgMaturityYears           float64
	ShareFXDebt                float64
	ShareConcessionalDebt      float64
	TaxRevenueGDP              float64
	PublicInvestmentGDP        float64
	SocialSpendingGDP          float64
	ClimateVulnerabilityIndex  float64
	MarketAccessIndex          float64
	GrowthRate                 float64
}

func parseRecord(row []string) (DebtRecord, error) {
	if len(row) != 17 {
		return DebtRecord{}, fmt.Errorf("invalid record length")
	}

	year, err := strconv.Atoi(row[2])
	if err != nil {
		return DebtRecord{}, err
	}

	values := make([]float64, 14)
	for i, col := range row[3:] {
		value, err := strconv.ParseFloat(col, 64)
		if err != nil {
			return DebtRecord{}, err
		}
		values[i] = value
	}

	return DebtRecord{
		Country:                   row[0],
		Region:                    row[1],
		Year:                      year,
		PublicDebtGDPRatio:        values[0],
		ExternalDebtExportRatio:   values[1],
		DebtServiceRevenueRatio:   values[2],
		InterestRevenueRatio:      values[3],
		GrossFinancingNeedsGDP:    values[4],
		AvgMaturityYears:          values[5],
		ShareFXDebt:               values[6],
		ShareConcessionalDebt:     values[7],
		TaxRevenueGDP:             values[8],
		PublicInvestmentGDP:       values[9],
		SocialSpendingGDP:         values[10],
		ClimateVulnerabilityIndex: values[11],
		MarketAccessIndex:         values[12],
		GrowthRate:                values[13],
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

func scale(value, lower, upper float64, inverse bool) float64 {
	scaled := clamp01((value - lower) / (upper - lower))
	if inverse {
		return 1 - scaled
	}
	return scaled
}

func overallConstraint(record DebtRecord) float64 {
	debtPressure := 0.18*scale(record.PublicDebtGDPRatio, 30, 120, false) +
		0.14*scale(record.ExternalDebtExportRatio, 50, 300, false) +
		0.20*scale(record.DebtServiceRevenueRatio, 5, 30, false) +
		0.12*scale(record.InterestRevenueRatio, 3, 20, false) +
		0.12*scale(record.GrossFinancingNeedsGDP, 5, 25, false) +
		0.10*scale(record.ShareFXDebt, 0.10, 0.80, false) +
		0.14*scale(record.ClimateVulnerabilityIndex, 0.20, 0.90, false)

	crowdingOut := 0.40*scale(record.DebtServiceRevenueRatio, 5, 30, false) +
		0.20*scale(record.InterestRevenueRatio, 3, 20, false) +
		0.20*scale(record.PublicInvestmentGDP, 1, 8, true) +
		0.20*scale(record.SocialSpendingGDP, 2, 18, true)

	refinancingRisk := 0.35*scale(record.GrossFinancingNeedsGDP, 5, 25, false) +
		0.25*scale(record.AvgMaturityYears, 2, 12, true) +
		0.20*scale(record.ShareFXDebt, 0.10, 0.80, false) +
		0.20*scale(record.MarketAccessIndex, 0.10, 0.95, true)

	return clamp01(0.40*debtPressure + 0.30*crowdingOut + 0.30*refinancingRisk)
}

func main() {
	file, err := os.Open("sovereign_debt_fiscal_space_data.csv")
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

		score := overallConstraint(record)
		fmt.Printf("country=%s region=%s year=%d overall_constraint_score=%.3f\n",
			record.Country, record.Region, record.Year, score)
	}
}
