all: examples

examples: test step fbuf interp video pitft

libMLX90640_API.so: functions/MLX90640_API.o functions/MLX90640_RPI_I2C_Driver.o
	$(CXX) -fPIC -shared $^ -o $@ -lbcm2835

libMLX90640_API.a: functions/MLX90640_API.o functions/MLX90640_RPI_I2C_Driver.o
	ar rcs $@ $^
	ranlib $@

functions/MLX90640_API.o functions/MLX90640_RPI_I2C_Driver.o : CXXFLAGS+=-fPIC -I headers -shared -lbcm2835

test.o step.o fbuf.o interp.o video.o pitft.o : CXXFLAGS+=-std=c++11

test step fbuf interp video pitft : CXXFLAGS+=-I.

test: examples/test.o libMLX90640_API.a
	$(CXX) -L/home/pi/mlx90640-library $^ -o $@ -lbcm2835

step: examples/step.o libMLX90640_API.a
	$(CXX) -L/home/pi/mlx90640-library $^ -o $@ -lbcm2835

fbuf: examples/fbuf.o examples/fb.o libMLX90640_API.a
	$(CXX) -L/home/pi/mlx90640-library $^ -o $@ -lbcm2835

interp: examples/interp.o examples/interpolate.o examples/fb.o libMLX90640_API.a
	$(CXX) -L/home/pi/mlx90640-library $^ -o $@ -lbcm2835

pitft: examples/pitft.o examples/interpolate.o examples/fb.o libMLX90640_API.a
	$(CXX) -L/home/pi/mlx90640-library $^ -o $@ -lbcm2835

video: examples/video.o examples/fb.o libMLX90640_API.a
	$(CXX) -L/home/pi/mlx90640-library $^ -o $@ -lbcm2835 -lavcodec -lavutil -lavformat

clean:
	rm -f test step fbuf interp video
	rm -f examples/*.o
	rm -f *.o
	rm -f *.so
	rm -f test
	rm -f *.a
