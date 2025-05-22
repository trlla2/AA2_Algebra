class BezierQuadratic {
  float p0, p1, p2;

  BezierQuadratic(float start, float control, float end) {
    this.p0 = start;
    this.p1 = control;
    this.p2 = end;
  }

  float evaluate(float t) {
    float oneMinusT = 1 - t;

    float term1 = oneMinusT * oneMinusT * p0;
    float term2 = 2 * oneMinusT * t * p1;
    float term3 = t * t * p2;

    return term1 + term2 + term3;
  }
}
