% 选择输入图像
[input_file, input_path] = uigetfile('*.jpg', 'Select an input image');  % 用户选择要识别的表情图像
if isequal(input_file, 0)
    disp('User canceled the operation.');
    return;
else
    full_file_path = fullfile(input_path, input_file);  % 构建完整路径
    disp(['Selected input file: ', full_file_path]);  % 确认文件路径
end

% 读取输入图像
input_image = imread(full_file_path);  % 使用完整路径读取图像
input_image_gray = rgb2gray(input_image);  % 将输入图像转换为灰度图

% 对输入图像进行归一化处理，减少光照和对比度的影响
input_image_gray = mat2gray(input_image_gray);  % 归一化,改成灰度图

% 使用完整的灰度图像
input_face = input_image_gray;  % 保持原始大小

% 表情类别
expressions = {'anger', 'disgust', 'fear', 'happiness', 'neutral', 'sadness', 'surprise'};
data_folder = 'D:\Code\DataBase\Faccial\tk1';  % 表情图片所在文件夹

% 存储每个表情类别的最大相关性值
max_corr_values = zeros(1, length(expressions));

% 遍历每个表情类别
for i = 1:length(expressions)
    expression = expressions{i};
    expression_folder = fullfile(data_folder, expression);  % 拼接路径，指向对应表情文件夹
    
    % 检查文件夹是否存在
    if ~exist(expression_folder, 'dir')
        fprintf('Folder for expression %s not found at %s\n', expression, expression_folder);
        continue;
    end
    
    % 获取该表情类别文件夹中的所有 .jpg 文件
    template_files = dir(fullfile(expression_folder, '*.jpg'));  % 动态获取所有 .jpg 文件
    num_templates = length(template_files);  % 获取模板文件数量
    
    % 检查是否有模板文件
    if num_templates == 0
        fprintf('No templates found for expression: %s\n', expression);
        continue;
    end
    
    % 遍历该表情类别下的所有模板图像
    for j = 1:num_templates
        template_file = fullfile(expression_folder, template_files(j).name);
        disp(['Processing template: ', template_file]);  % 输出文件路径，调试时使用
        
        % 检查文件是否存在
        if exist(template_file, 'file')
            template_image = imread(template_file);  % 读取模板图像
            template_image_gray = rgb2gray(template_image);  % 转为灰度图
            
            % 对模板图像进行归一化
            template_image_gray = mat2gray(template_image_gray);  % 归一化模板图像
            
            % 执行归一化互相关计算
            norm_corr = normxcorr2(template_image_gray(:,:,1), input_face(:,:,1));
            
            % 记录该表情类别的最大相关性值
            max_corr_values(i) = max(max_corr_values(i), max(norm_corr(:)));
        else
            fprintf('File %s not found.\n', template_file);
        end
    end
end

% 输出每个表情类别的最大相关性值
for i = 1:length(expressions)
    fprintf('Expression: %s, Max correlation: %f\n', expressions{i}, max_corr_values(i));
end

% 找到匹配度最高的表情类别
[~, best_match_idx] = max(max_corr_values);
best_expression = expressions{best_match_idx};

% 输出识别结果
fprintf('Detected expression: %s\n', best_expression);

% 在图像上绘制检测到的表情
figure;
imshow(input_image_gray);
title(sprintf('Detected expression: %s', best_expression));
