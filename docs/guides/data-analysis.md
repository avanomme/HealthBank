# Data Analysis Dependencies

## Overview

The research data analytics feature uses Python data science libraries for aggregating survey response data with privacy-preserving k-anonymity enforcement.

## Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `pandas` | >= 2.2.0 | DataFrame operations, grouping, CSV export |
| `numpy` | >= 1.26.0 | Statistical calculations (mean, median, std_dev) |

## Installation

```bash
cd backend
uv pip install -r requirements.txt
```

## Usage

These libraries are used by the `AggregationService` (`backend/app/services/aggregation.py`) to:

- Query and aggregate survey responses from the `Responses` table
- Compute statistics (min, max, mean, median, std_dev) for numeric responses
- Generate histogram bucket distributions
- Count and percentage calculations for choice-based questions
- Export aggregate data as CSV via `DataFrame.to_csv()`

## Privacy

All aggregation enforces **k-anonymity** with a threshold of **K=5**. Any group with fewer than 5 responses is suppressed and not returned to the client. Individual response values are never exposed.
