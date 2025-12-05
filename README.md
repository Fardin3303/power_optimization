# Rivervault Crisis: Hydropower Optimization Solution

## 🚀 Quick Start

### Prerequisites
- Julia 1.6 or higher
- Bash shell (Linux/macOS/WSL)

### Setup and Run

**1. Run the setup script to install Julia packages:**
```bash
./setup_julia_environment.sh
```

**2. Open and run the Julia Jupyter notebook:**
```bash
# Open rivervault_crisis_sddp_julia.ipynb in VS Code with Julia extension
# Or use Jupyter with IJulia kernel
```

**3. In VS Code or Jupyter:**
- Select the Julia kernel/interpreter
- Run all cells in the notebook
- The test scenario answer will be displayed: **400,000 ₲**

### Required Julia Packages (auto-installed by setup script)
- `SDDP.jl` - Stochastic Dual Dynamic Programming optimization framework
- `HiGHS.jl` - Fast LP/MIP solver (for deterministic models)
- `Ipopt.jl` - Nonlinear optimization solver (for SDDP approach)
- `DataFrames.jl` - Data manipulation
- `Plots.jl` - Visualization
- `Statistics.jl` - Statistical functions

---

## 🌊 Problem Overview

The **Gnomish City of Rivervault** faces a critical energy crisis after an earthquake damaged their geothermal power station. This project solves a complex hydropower optimization problem to help the gnomes manage their water resources optimally during the 7-day emergency period.

### 🏗️ System Architecture

```
[Lake 1] → [Plant 1] → [Lake 2] → [Plant 2] → [Lake 3] → [Plant 3] → River
   ↑           ↓           ↑           ↓           ↑           ↓
 Inflow    Energy      Inflow    Energy      Inflow    Energy
```

**Three cascading hydropower plants** are connected in series, where:
- Water used by Plant 1 flows into Lake 2
- Water used by Plant 2 flows into Lake 3  
- Water used by Plant 3 exits to the river

## ⚡ The Challenge

### Current Situation
- ❌ **Geothermal station offline** for 1 week (earthquake damage)
- ⚠️ **Previous flooding incident** from overusing hydro plants
- 💰 **High electricity prices** on external grid (cannot sell back)
- 🌊 **Uncertain forecasts** for water inflows and electricity prices

### Constraints & Requirements
1. **Energy Demand**: Must meet exact daily energy requirements (248-510 units)
2. **Lake Volume Limits**:
   - **Minimum**: Below this, downstream plants cannot operate
   - **Maximum**: Above this, environmental damage costs occur (10,000 ₲/unit/day)
   - **Critical**: Above this, village floods (GAME OVER!)
3. **Water Balance**: Inflow + upstream discharge = usage + final storage + spillage
4. **No Energy Sales**: Can only buy electricity, not sell excess

### Lake Specifications
| Lake | Current | Min | Max | Critical | 
|------|---------|-----|-----|----------|
| Lake 1 | 200 | 150 | 250 | 300 |
| Lake 2 | 160 | 140 | 180 | 230 |
| Lake 3 | 190 | 110 | 150 | 200 |

## 📊 Test Scenario Data

### Daily Energy Demand (Water Units)
| Day | Monday | Tuesday | Wednesday | Thursday | Friday | Saturday | Sunday |
|-----|--------|---------|-----------|----------|--------|----------|--------|
| Demand | 248.0 | 103.0 | 85.0 | 75.0 | 65.0 | 88.0 | 510.0 |

### Electricity Prices (₲ per unit)
| Day | Monday | Tuesday | Wednesday | Thursday | Friday | Saturday | Sunday |
|-----|--------|---------|-----------|----------|--------|----------|--------|
| Price | 950.0 | 850.0 | 120.0 | 5.0 | 2.0 | 250.5 | 741.0 |

### Water Inflows (Units per day)
| Day | Lake 1 | Lake 2 | Lake 3 |
|-----|--------|--------|--------|
| Monday | 31.0 | 21.0 | 11.0 |
| Tuesday | 30.0 | 29.0 | 10.0 |
| Wednesday | 37.0 | 13.0 | 9.0 |
| Thursday | 13.0 | 3.0 | 3.0 |
| Friday | 39.0 | 12.0 | 21.0 |
| Saturday | 24.0 | 18.0 | 21.0 |
| Sunday | 27.0 | 25.0 | 30.0 |

## 🎯 Solution Approach

### Mathematical Model
**Optimization Type**: Linear Programming (LP) with deterministic approach and scenario analysis
**Objective**: Minimize total cost = Electricity purchases + Water damage penalties

### Decision Variables
- `water_used[plant, day]`: Water used by each plant each day
- `electricity_bought[day]`: Electricity purchased from grid each day
- `lake_volume[lake, day]`: Water volume in each lake at end of day
- `spillage[lake, day]`: Water spilled above maximum level

### Key Constraints
1. **Energy Balance**: `Hydropower + Purchased = Demand` (daily)
2. **Water Balance**: `Initial + Inflow + Upstream - Used = Final + Spillage` (per lake, daily)
3. **Volume Limits**: `Min ≤ Lake Volume ≤ Max` and `Lake Volume + Spillage ≤ Critical`
4. **Non-negativity**: All variables ≥ 0

## 🏆 Results & Answer

### 🎯 **MAIN ANSWER**: **400,000 ₲**

The optimization model determines that **the total cost for the test scenario is 400,000 ₲**.

### Why This Cost?

The optimal solution shows that:
- ✅ **100% Hydropower**: All 1,174 units of weekly energy demand met using only hydro plants
- ✅ **Zero Grid Purchases**: No electricity bought from expensive external grid  
- ⚠️ **Initial Damage Cost**: 400,000 ₲ due to Lake 3 starting above maximum (190 > 150)
- ✅ **No Additional Damage**: After Day 1, all lakes managed within safe bounds

### Why 400,000 ₲?

**Lake 3 Crisis Situation:**
- Lake 3 starts at **190 units** (overfilled from previous operations)
- Maximum safe level is **150 units**
- Overflow: 190 - 150 = **40 units**
- Damage cost: 40 units × 10,000 ₲/unit = **400,000 ₲**

This is a **one-time unavoidable cost** on Day 1 due to the initial conditions. The optimal strategy immediately uses water from Lake 3 to reduce the overflow and prevent further damage.

### Operational Strategy

The optimal solution manages the crisis by:
1. **Day 1**: Immediately use excess water from Lake 3 to reduce overflow
2. **Days 2-7**: Maintain all lakes within safe limits
3. **Throughout**: Meet all demand through hydropower, no grid purchases needed

**Key Result**: Only the initial 400,000 ₲ damage cost is unavoidable. Perfect water management prevents any additional costs.

### 💰 Cost Savings Analysis

**Avoided Grid Purchase Cost**: **733,809 ₲**

If the gnomes had purchased all electricity from the grid instead of optimizing hydropower:
- Monday alone would have cost: 950 × 248 = **235,600 ₲**
- Sunday alone would have cost: 741 × 510 = **377,910 ₲**  
- **Total avoided electricity cost: 733,809 ₲**
- **Net benefit**: Saved 733,809 ₲ in electricity costs, paid only 400,000 ₲ in initial damage
- **Total savings**: **333,809 ₲** compared to buying all power from grid

## 🔮 Advanced Analysis: Two Optimization Approaches

The notebook implements **two different approaches** to solving the problem:

### 1. Deterministic Approach (Sections 3-5) ✅ **Recommended**

**What it is:**
- Solves the entire 7-day problem as a **single optimization** with known future values
- Uses the TEST scenario data (specific prices and inflows)
- Finds the **globally optimal solution** for that exact scenario

**How it uses data:**
```julia
# Fixed values from test scenario
price = TEST_PRICES[stage]
inflows = TEST_INFLOWS[stage]
```

**Results:**
- **Cost**: 400,000 ₲ (exact optimal for test scenario)
- **Solver**: HiGHS (fast, < 1 second)
- **Use case**: Assignment answer

### 2. Stochastic SDDP Approach (Sections 6-8) 🎓 **Advanced Alternative**

**What it is:**
- **Stochastic Dual Dynamic Programming** - multi-stage stochastic optimization
- Solves **stage-by-stage** (day-by-day) without knowing which scenario will occur
- Builds a **policy** (decision rule) that adapts to uncertainty
- Uses **both Forecast A and Forecast B** (50% probability each)

**How it uses data:**
```julia
# Random variables that can take different values
@variable(subproblem, ω_price)
@variable(subproblem, ω_inflow[1:LAKES])

SDDP.parameterize(subproblem, scenarios, probabilities) do scenario
    if scenario == 1  # Forecast A
        fix(ω_price, PRICES_A[stage])
        fix(ω_inflow[i], INFLOWS_A[stage][i])
    else  # Forecast B
        fix(ω_price, PRICES_B[stage])
        fix(ω_inflow[i], INFLOWS_B[stage][i])
    end
end
```

**What is `fix()`?**
- `fix(variable, value)` sets a variable to a specific constant value
- Used to assign scenario-specific data to random variables
- Tells SDDP: "These values change depending on which scenario occurs"
- The optimizer then learns decision rules that work well across all scenarios

**Results:**
- **Expected Cost**: ~473,000 ₲ (averaged across scenarios A & B)
- **Solver**: Ipopt (~10 seconds training)
- **Use case**: Real-world systems with uncertainty

### 📊 Comparison Table

| Aspect | Deterministic | Stochastic SDDP |
|--------|---------------|-----------------|
| **Input Data** | TEST scenario only | Forecast A & B (50/50) |
| **Assumption** | Perfect knowledge of future | Uncertain future |
| **Output** | Optimal plan for test case | Adaptive policy for any scenario |
| **Cost** | 400,000 ₲ (exact) | ~473,000 ₲ (hedges uncertainty) |
| **Solver** | HiGHS | Ipopt |
| **Training Time** | < 1 second | ~10 seconds |
| **Best For** | Known scenarios | Unknown future, long horizons |

### 🎯 Key Insight: Why Different Results?

**They solve different problems:**
- **Deterministic**: "Here's the exact forecast, find the perfect plan" → 400,000 ₲
- **Stochastic**: "Forecast could be A or B, find a policy that works for both" → 473,000 ₲

The stochastic cost is higher because it must **hedge against uncertainty** - making more conservative decisions that work reasonably well for multiple scenarios rather than being perfectly optimized for one.

### When to Use Each Approach:

**Use Deterministic when:**
- You have a specific scenario to solve (like the assignment test case)
- Short time horizons (7 days = 2^7 = 128 scenario paths)
- Need exact optimal answer for known data

**Use Stochastic SDDP when:**
- Long horizons (52+ weeks, for example, where 2^52 scenarios become intractable)
- Need adaptive policies for real-time decision support
- Operating under genuine uncertainty
- Building decision support systems

## 🛠️ Technical Implementation

### Tools Used
- **Julia**: High-performance programming language for mathematical optimization
- **SDDP.jl**: Multi-stage stochastic optimization framework
- **HiGHS**: Fast linear programming solver (deterministic approach)
- **Ipopt**: Interior point optimizer (stochastic SDDP approach)
- **JuMP**: Embedded domain-specific language for optimization (used internally by SDDP.jl)
- **DataFrames.jl/Plots.jl**: Data manipulation and visualization
- **Jupyter Notebook**: Interactive development environment

### Mathematical Model

**Decision Variables:**
- `water_used[lake, day]` = Water used by power plant at each lake
- `electricity_bought[day]` = Electricity purchased from grid
- `volume[lake, day]` = Lake volume at end of day
- `damage[lake, day]` = Overflow above maximum level

**Objective Function:**
```
Minimize: Σ (price[day] × electricity_bought[day]) + Σ (10,000 × damage[lake, day])
```

**Key Constraints:**
1. **Energy Balance**: `Σ water_used + electricity_bought = DEMAND[day]`
2. **Water Balance**: `volume[t] = volume[t-1] + inflow + upstream_discharge - usage`
3. **Volume Limits**: `MIN ≤ volume ≤ CRITICAL`
4. **Damage**: `damage ≥ volume - MAX`

### Ancient Gnomish Wisdom Decoded

The mysterious hint **"Julia lang"** and **"SDDP"** refers to:
- **Julia**: Modern high-performance language designed for scientific computing and optimization
- **SDDP**: Stochastic Dual Dynamic Programming - the state-of-the-art algorithm for multi-stage stochastic optimization problems

This wisdom proved essential for implementing both deterministic and stochastic approaches efficiently!

## 📈 Solution Features

The Julia notebook includes:
1. **Deterministic Optimization**: Fast, exact solution for the test scenario
2. **Stochastic SDDP Implementation**: Advanced uncertainty modeling
3. **Detailed Analysis**: Day-by-day breakdown of decisions
4. **Policy Simulation**: Monte Carlo analysis of SDDP policy performance
5. **Comprehensive Documentation**: Mathematical formulations and explanations

## 🎯 Key Takeaways

### For the Assignment:
- **Answer: 400,000 ₲** (from deterministic approach, Section 4)
- Due to Lake 3 starting 40 units above maximum
- No electricity purchases needed - 100% hydropower solution

### For Understanding Optimization:
- **Deterministic vs Stochastic**: Different approaches for different purposes
- **Trade-off**: Exact optimality (deterministic) vs robustness (stochastic)
- **Cascading Systems**: Upstream decisions affect downstream resources
- **Multi-stage Decisions**: Today's choices impact future options

## 🏁 Conclusion

The Rivervault Crisis optimization successfully demonstrates that:

✅ **Mathematical optimization prevents catastrophe** (avoided 733K ₲ in electricity costs)  
✅ **Proper water management minimizes damage** (only 400K ₲ unavoidable initial cost)  
✅ **Renewable energy can meet demand** (100% hydropower solution)  
✅ **Julia + SDDP.jl enables advanced optimization** (both deterministic and stochastic approaches)
✅ **Ancient gnomish wisdom remains relevant** (SDDP methods for managing uncertainty)

The gnomes now have a robust, data-driven solution to navigate their energy crisis while protecting both their finances and their village! 🧙‍♂️⚡🌊

---

## 📝 Files in Repository

- `rivervault_crisis_sddp_julia.ipynb` - Main Julia notebook with both approaches
- `setup_julia_environment.sh` - Automatic setup script for Julia packages
- `README.md` - This comprehensive documentation
- `assignment.txt` - Original problem statement
- `SIMPLE_EXPLANATION.txt` - Simplified problem overview

---

## 📚 References

This solution was implemented using the **SDDP.jl** library for Julia:

- **SDDP.jl Documentation**: [https://sddp.dev/stable/](https://sddp.dev/stable/)
  - Comprehensive guide to Stochastic Dual Dynamic Programming in Julia
  - Examples of multi-stage stochastic optimization
  - API reference for `LinearPolicyGraph`, `@stageobjective`, `parameterize`, and more

The SDDP.jl documentation was instrumental in implementing both the deterministic and stochastic approaches used in this project.