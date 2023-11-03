image_names = ["SaltLake" "mandala5" "lizard5" "LittleHouses" "leaf" "kodim13" "kodim05" "kodim04" "kodim01" "DragonFly"];
n = 10;  % choose image number with respect to the array above

R = cellstr(arrayfun(@num2str, 1:50, 'UniformOutput', false)); % Generate the R values as cell array
psnr_original = zeros(1, 50);
psnr_def_aware = zeros(1, 50);

ssim_original = zeros(1, 50);
ssim_def_aware = zeros(1, 50);

bitrate_original = zeros(1, 50);
bitrate_def_aware = zeros(1, 50);

path_1 = "/MATLAB Drive/DeformationAwareCompressionCode/DeformationAwareCompressionCode/Out/jpeg/";

image = image_names(n);

decom_def_aware_path_2 = "/x_DeformationAware.png";
decom_original_path_2 = "/x_original.png";
def_aware_path_2 = "/x_DeformationAware.jpg";
original_path_2 = "/x_original.jpg";
input_path_2 = "/Input.png";
y_path_2 = "/y.png";

data = zeros(50, 7); % Create an array to store the data (50 rows and 7 columns)

for nR = 1:50
    decom_def_aware_path = strcat(path_1, image, "/R=", R{nR}, decom_def_aware_path_2);
    decom_original_path = strcat(path_1, image, "/R=", R{nR}, decom_original_path_2);
    def_aware_path = strcat(path_1, image, "/R=", R{nR}, def_aware_path_2);
    original_path = strcat(path_1, image, "/R=", R{nR}, original_path_2);
    input_path = strcat(path_1, image, "/R=", R{nR}, input_path_2);
    y_path = strcat(path_1, image, "/R=", R{nR}, y_path_2);

    decom_def_aware = imread(decom_def_aware_path);
    decom_original = imread(decom_original_path);
    def_aware = imread(def_aware_path);
    original = imread(original_path);
    input = imread(input_path);
    y = imread(y_path);

    org_file = dir(original_path);
    org_file_bytes = org_file.bytes;
    org_pixel = numel(original);
    org_brpp = (8 * org_file_bytes) / org_pixel;
    bitrate_original(nR) = org_brpp;

    def_file = dir(def_aware_path);
    def_file_bytes = def_file.bytes;
    def_pixel = numel(def_aware);
    def_brpp = (8 * def_file_bytes) / def_pixel;
    bitrate_def_aware(nR) = def_brpp;

    or_psnr = psnr(decom_original, input);
    df_psnr = psnr(decom_def_aware, y);
    psnr_original(nR) = or_psnr;
    psnr_def_aware(nR) = df_psnr;

    or_ssim = ssim(decom_original, input);
    df_ssim = ssim(decom_def_aware, y);
    ssim_original(nR) = or_ssim;
    ssim_def_aware(nR) = df_ssim;

    % Store the data in the data array
    data(nR, :) = [nR, or_psnr, df_psnr, or_ssim, df_ssim, org_brpp, def_brpp];

    fprintf("Processed R: %d\n", nR);
end

% Write the data to a CSV file
csv_file_name = 'compression_data.csv';
csv_header = {'R', 'PSNR_Original', 'PSNR_Def_Aware', 'SSIM_Original', 'SSIM_Def_Aware', 'Bitrate_Original', 'Bitrate_Def_Aware'};

% Write data to CSV file with header
writecell(csv_header, csv_file_name); % Write the header

% Append data without headers
writematrix(data, csv_file_name, 'WriteMode', 'append');

disp("Data saved to " + csv_file_name);