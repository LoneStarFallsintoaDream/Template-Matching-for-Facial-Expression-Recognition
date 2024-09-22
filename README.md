# Template-Matching-for-Facial-Expression-Recognition
A project utilizing the template matching algorithm to detect and recognize facial expressions in images, with potential to recognize other objects.

The basic idea of the template matching algorithm is to compare the template image with various sub-regions of the image to be recognized through a sliding window, calculating the similarity to find the region that best matches the template. In the code, normalized cross-correlation (NCC) is used to measure similarity. The value of NCC ranges from -1 to 1, with values closer to 1 indicating a higher degree of matching.
