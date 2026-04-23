from __future__ import annotations

import pandas as pd
import numpy as np

INPUT_FILE = "participation_and_cld_panel.csv"
OUTPUT_FILE = "participation_and_cld_scores.csv"


def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)

    required_columns = [
        "country",
        "region",
        "program_domain",
        "participatory_depth_index",
        "voice_effectiveness_index",
        "representation_quality_index",
        "institutional_uptake_index",
        "community_control_index",
        "accountability_channel_index",
        "local_knowledge_integration_index",
        "trust_support_index",
        "tokenism_risk_index",
    ]

    missing = [col for col in required_columns if col not in df.columns]
    if missing:
        raise ValueError(f"Missing required columns: {missing}")

    return df


def validate_indices(df: pd.DataFrame) -> pd.DataFrame:
    index_columns = [col for col in df.columns if col.endswith("_index")]
    for col in index_columns:
        if ((df[col] < 0) | (df[col] > 1)).any():
            raise ValueError(f"Column '{col}' contains values outside [0, 1].")
    return df


def compute_scores(df: pd.DataFrame) -> pd.DataFrame:
    df = df.copy()

    df["participatory_legitimacy_score"] = (
        0.22 * df["participatory_depth_index"] +
        0.20 * df["voice_effectiveness_index"] +
        0.20 * df["representation_quality_index"] +
        0.18 * df["institutional_uptake_index"] +
        0.20 * df["trust_support_index"]
    ).clip(lower=0, upper=1)

    df["community_led_development_score"] = (
        0.30 * df["community_control_index"] +
        0.20 * df["local_knowledge_integration_index"] +
        0.20 * df["institutional_uptake_index"] +
        0.15 * df["accountability_channel_index"] +
        0.15 * df["representation_quality_index"]
    ).clip(lower=0, upper=1)

    df["constrained_participation_score"] = (
        0.40 * df["participatory_legitimacy_score"] +
        0.35 * df["community_led_development_score"] +
        0.15 * df["accountability_channel_index"] +
        0.10 * (1 - df["tokenism_risk_index"])
    ).clip(lower=0, upper=1)

    df["participation_band"] = np.select(
        [
            df["constrained_participation_score"] >= 0.80,
            df["constrained_participation_score"] >= 0.60,
            df["constrained_participation_score"] >= 0.40,
        ],
        [
            "High participatory capacity",
            "Strong participatory capacity",
            "Moderate participatory capacity",
        ],
        default="Constrained participatory capacity",
    )

    return df


def build_summary(df: pd.DataFrame) -> pd.DataFrame:
    cols = [
        "country",
        "region",
        "program_domain",
        "participatory_legitimacy_score",
        "community_led_development_score",
        "constrained_participation_score",
        "participation_band",
    ]
    summary = df[cols].copy()
    summary = summary.sort_values(
        by=[
            "constrained_participation_score",
            "participatory_legitimacy_score",
            "community_led_development_score",
        ],
        ascending=[False, False, False],
    )
    return summary


def main() -> None:
    df = load_data(INPUT_FILE)
    df = validate_indices(df)
    scored = compute_scores(df)
    summary = build_summary(scored)

    summary.to_csv(OUTPUT_FILE, index=False)

    print("Participation and community-led development scoring complete.")
    print(summary.to_string(index=False))


if __name__ == "__main__":
    main()
