from algorithm.graphics import Graphics
from algorithm.file_operations import FileOperations
from algorithm.random_dots import RandomDots
from algorithm.gradient_descent import GradientDescent


class LogisticRegression:

    def calculate(self):

        X1, X2, Y = FileOperations.read_dots_coords()
        # X1, X2, Y = RandomDots.generate_rand_coords()
        # FileOperations.write_dots_coords(X1, X2, Y)
        
        w, b, mu, X_norm = GradientDescent().calculate_params(X1, X2, Y)

        Graphics.plot_dots(X1, X2, Y, w, b, mu, X_norm)

