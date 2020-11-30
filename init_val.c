#include <stdio.h>
#include <math.h>
#include <stdint.h>

double triangle(double val) {
	if (val < M_PI / 2)
		return val / (M_PI/2);
	if (val < M_PI * 3. / 2.)
		return 2 - (val / (M_PI/2));
	if (val < 2 * M_PI)
		return (val / (M_PI/2)) - 4;
	return 0;
}

int main(void) {
	FILE* sin_file = fopen("init_val_sin.mem", "w");
	FILE* triangle_file = fopen("init_val_triangle.mem", "w");

	for (int iter = 0; iter < 16; ++iter) {
		int8_t sin_val = INT8_MAX * sin(iter * 2. * M_PI / 16);
		int8_t triangle_val = INT8_MAX * triangle(iter * 2. * M_PI / 16);

		fprintf(sin_file, "%x ", sin_val);
		fprintf(triangle_file, "%x ", triangle_val);
	}

	fclose(sin_file);
	fclose(triangle_file);
}
