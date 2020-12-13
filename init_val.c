#include <stdio.h>
#include <math.h>
#include <stdint.h>
#include <stdlib.h>

#include <unistd.h>

double triangle(double val) {
	if (val < M_PI / 2)
		return val / (M_PI/2);
	if (val < M_PI * 3. / 2.)
		return 2 - (val / (M_PI/2));
	if (val < 2 * M_PI)
		return (val / (M_PI/2)) - 4;
	return 0;
}

void usage(const char *program_name) {
	fprintf(stderr, "Usage: %s [-s samples_no] [-a amplitudes_no]\n", program_name);
}

int main(int argc, char *argv[]) {
	FILE *sin_file = fopen("init_val_sin.mem", "w");
	FILE *triangle_file = fopen("init_val_triangle.mem", "w");

	int ch;
	int samples_no = 16;
	int amplitudes_no = 1;

	while ((ch = getopt(argc, argv, "s:a:")) != -1) {
		switch (ch) {
		case 's':
			sscanf(optarg, "%d", &samples_no);
			break;
		case 'a':
			sscanf(optarg, "%d", &amplitudes_no);
			break;
		default:
			usage(argv[0]);
			samples_no = 0;
		}
	}

	for (int amp_iter = 0; amp_iter < amplitudes_no; ++amp_iter) {
		int nominator = amplitudes_no == 1 ? 1 : amp_iter;
		int denominator = amplitudes_no == 1 ? 1 : amplitudes_no - 1;
		for (int iter = 0; iter < samples_no; ++iter) {
			int8_t sin_val = INT8_MAX * sin(iter * 2. * M_PI / samples_no);
			int8_t triangle_val = INT8_MAX * triangle(iter * 2. * M_PI / samples_no);

			sin_val = nominator * sin_val / denominator;
			triangle_val = nominator * triangle_val / denominator;

			fprintf(sin_file, "%2x ", (uint8_t)sin_val);
			fprintf(triangle_file, "%2x ", (uint8_t)triangle_val);
		}
		fprintf(sin_file, "\n");
		fprintf(triangle_file, "\n");
	}

	fclose(sin_file);
	fclose(triangle_file);
}
