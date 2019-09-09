# V5.1 ➡ V5.2

_Minor release supporting Vega 5.6._

## Additions

- `kdResolve` and associated `reShared` and `reIndependent` functions for resolving multiple densities in a KDE transform.
- `bnSpan` for setting the span over which bins are calculated.
- `equalEarth` core map projection added.
- `identityProjection` and associated `reflectX` and `reflectY` map projection functions added.
- `leBorderStrokeDash` for configuring legend border dash style.
- `cfSignals` for supporting configuration signals (Vega 5.5).
- `cfEventHandling` and associated `cfe` functions for more flexible Vega 5.5 event configuration.

## Deprecations

- `cfEvents` deprecated in favour of `cfEventHandling [cfeDefaults ...]`

## Bug Fixes

- `cfGroup` mark properties now correctly create literals rather than objects (e.g. `"fill": "#eee"` rather than `"fill":{"value":"#eee"}`).

## Other Changes

- Minor improvements to the API documentation.
- Update examples to use Vega-embed 5 and Vega 5.5 runtimes
- Minor additions to tests.

---

# V5.0 ➡ V5.1

_Minor release to align with Vega 5.4._

## Additions

- `leX` and `leY` for top level legend positioning.
- `topojsonMeshInterior` and `topojsonMeshExterior` for interior and exterior filtering of topoJson meshes.
- `dnMinSteps` and `dnMaxSteps` added to `trDensity` options
- `trKde` transform for 1-d KDE from a distribution.
- `trRegression` transformation function.
- `trLoess` locally estimated regression function.
- `vGradient` and `vGradientScale` functions for setting gradient fills/strokes.
- `woPrevValue` and `woNextValue` for previous and next value window value operations.
- `arrow` file format indicator for loading binary apache arrow files.

## Other Changes

- Regression examples added to gallery
- Tests for new functions

---

# V4.3.1 ➡ V5.0

_Major release to align with Vega 5.3._

## Breaking Changes

_These reflect breaking changes from Vega 4 -> Vega 5_

- `scBinLinear` removed. Use `scLinear` with the new `scBins` instead.
- `leStrokeWidth` now takes the name of scale for mapping legend stroke width rather than a numeric literal. For legend border configuration, use the new `leBorderStrokeWidth`.
- `leTitlePadding`, `leOffset` and `lePadding` now take a number rather than value (for consistency with other legend numeric parameters).
- While not an API change, continuous color schemes no longer support discrete variants as part of the scheme name. Replace `raScheme (str "blues-7") []` with `raScheme (str "blues") [csCount (num 7)]`

## Additions

- `scBins` for specifying the bin boundaries for a bin scaling. Associated functions `bsBins`, `bsNums` and `bsSignal` for customising bin boundaries.
- `scSymLog` and `scConstant` for symmetrical log scaling of data that may contain zero or negative values.
- `symTriangle`, `symArrow` and `symWedge` directional symbol types useful for new support for angle encoding of symbols.
- `symStroke` for legend symbols
- New axis configurations (`axDomainDash`, `axDomainDashOffset`, `axFormatAsNum`, `axFormatAsTemporal`, `axGridDashOffset`, `axLabelFontStyle`, `axLabelSeparation`, `axTickDash`, `axTickDashOffset`, `axTickMinStep`, `axTitleAnchor` and `axTitleFontStyle`.)
- New legend configurations (`leBorderStrokeWidth`, `leFormatAsNum`, `leFormatAsTemporal`, `leLabelFontStyle`, `leLabelSeparation`, `leSymbolDash`, `leSymbolDashOffset`, `leTickMinStep`, `leTitleAnchor`, `leTitleFontStyle` and `leTitleOrient`.)

## Deprecations

`scSequential` in favour of `scLinear`.

## Documentation / Asset Changes

- Wind vector example added to test-gallery
- Other examples updated to reflect latest API