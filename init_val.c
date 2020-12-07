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
	fprintf(stderr, "Usage: %s [-s samples_no]\n", program_name);
}

int main(int argc, char *argv[]) {
	FILE *sin_file = fopen("init_val_sin.mem", "w");
	FILE *triangle_file = fopen("init_val_triangle.mem", "w");

	int ch;
	int samples_no = 16;

	while ((ch = getopt(argc, argv, "s:")) != -1) {
		switch (ch) {
		case 's':
			sscanf(optarg, "%d", &samples_no);
			break;
		default:
			usage(argv[0]);
			samples_no = 0;
		}
	}

	for (int iter = 0; iter < samples_no; ++iter) {
		int8_t sin_val = INT8_MAX * sin(iter * 2. * M_PI / samples_no);
		int8_t triangle_val = INT8_MAX * triangle(iter * 2. * M_PI / samples_no);

		fprintf(sin_file, "%x ", (uint8_t)sin_val);
		fprintf(triangle_file, "%x ", (uint8_t)triangle_val);
	}

	fclose(sin_file);
	fclose(triangle_file);
}
