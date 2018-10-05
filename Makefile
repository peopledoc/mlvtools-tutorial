SHELL := /bin/bash
develop:
	pip install -r ./requirements.txt

init-struct:
	mkdir -p poc/pipeline/notebooks
	mkdir -p poc/pipeline/steps
	mkdir -p poc/commands/dvc
	mkdir -p poc/data


mlvtools-conf:
	echo -e "{\n" \
"\"path\": {\\n" \
"\\t\"python_script_root_dir\": \"./poc/pipeline/steps\",\\n" \
"\\t\"dvc_cmd_root_dir\": \"./poc/commands/dvc\"\\n" \
"\\t}\\n}\\n"  > ./.mlvtools

dummy-conf:
	echo -e "{\n" \
"\"path\": {\\n" \
"\\t\"python_script_root_dir\": \"./dummy/pipeline/steps\",\\n" \
"\\t\"dvc_cmd_root_dir\": \"./dummy/dvc\"\\n" \
"\\t}\\n}\\n"  > ./.mlvtools


dummy-struct:
	mkdir -p dummy/pipeline/notebooks
	mkdir -p dummy/pipeline/steps
	mkdir -p dummy/dvc
	mkdir -p dummy/data

download-data:
	echo "Download tutorial input data"
	./download_data.py

change-input-data:
	echo "Change tutorial input data"
	./modify_input_data.py

clean-all:
	rm -rf poc dummy
	rm -f .mlvtools
	rm -rf mlruns
	find . -name '*.dvc' -type f -delete
	find . -name '*.pyc' -delete
	find . -name '__pycache__' -delete
	rm -rf .dvc
	rm -f *.egg


setup: init-struct mlvtools-conf develop download-data
	pip install --upgrade nbstripout
	nbstripout --install
	dvc init
	git add .mlvtools && git commit -am 'Fast setup'


dummy-input:
	cp ./resources/dummy/dummy_pipeline_feed.txt ./dummy/data/dummy_pipeline_feed.txt

dummy-input2:
	cp ./resources/dummy/dummy_pipeline_feed_2.txt ./dummy/data/dummy_pipeline_feed.txt

dummy-input3:
	cp ./resources/dummy/dummy_pipeline_feed_3.txt ./dummy/data/dummy_pipeline_feed.txt

define run_step
	# Copy resource to project pipeline directory
	# and then open the notebook, read info about parameters and try it.
	cp ./resources/$(1) ./poc/pipeline/notebooks/
	# Convert to Python 3 script
	ipynb_to_python -n ./poc/pipeline/notebooks/$(1) -f
	# Generate commands
	gen_dvc -i ./poc/pipeline/steps/mlvtools_$(2).py -f
	# Run
	./poc/commands/dvc/mlvtools_$(2)_dvc
endef

us1-step1:
	dvc add ./poc/data/20news-bydate_py3.pkz
	$(call run_step,01_Extract_dataset.ipynb,01_extract_dataset)

us1-step2:
	$(call run_step,02_Tokenize_text.ipynb,02_tokenize_text)

us1-step3:
	$(call run_step,03_Classify_text.ipynb,03_classify_text)

us1-step4:
	$(call run_step,04_Evaluate_model.ipynb,04_evaluate_model)

us1-step5:
	cp ./poc/commands/dvc/mlvtools_02_tokenize_text_dvc ./poc/commands/dvc/mlvtools_02_test_tokenize_text_dvc
	sed -i 's#INPUT_CSV_FILE="./poc/data/data_train.csv"#INPUT_CSV_FILE="./poc/data/data_test.csv"#g' \
	./poc/commands/dvc/mlvtools_02_test_tokenize_text_dvc
	sed -i 's#OUTPUT_CSV_FILE="./poc/data/data_train_tokenized.csv"#OUTPUT_CSV_FILE="./poc/data/data_test_tokenized.csv"#g' \
	./poc/commands/dvc/mlvtools_02_test_tokenize_text_dvc
	sed -i 's#MLV_DVC_META_FILENAME="mlvtools_02_tokenize_text.dvc"#MLV_DVC_META_FILENAME="mlvtools_02_test_tokenize_text.dvc"#g' \
		./poc/commands/dvc/mlvtools_02_test_tokenize_text_dvc
	./poc/commands/dvc/mlvtools_02_test_tokenize_text_dvc


us1-step6:
	cp ./poc/commands/dvc/mlvtools_04_evaluate_model_dvc ./poc/commands/dvc/mlvtools_04_evaluate_test_model_dvc
	sed -i 's#DATA_FILE="./poc/data/data_train_tokenized.csv"#DATA_FILE="./poc/data/data_test_tokenized.csv"#g' \
	./poc/commands/dvc/mlvtools_04_evaluate_test_model_dvc
	sed -i 's#RESULT_FILE="./poc/data/metrics.txt"#RESULT_FILE="./poc/data/metrics_test.txt"#g' \
	./poc/commands/dvc/mlvtools_04_evaluate_test_model_dvc
	sed -i 's#MLV_DVC_META_FILENAME="mlvtools_04_evaluate_model.dvc"#MLV_DVC_META_FILENAME="mlvtools_04_evaluate_test_model.dvc"#g' \
		./poc/commands/dvc/mlvtools_04_evaluate_test_model_dvc
	./poc/commands/dvc/mlvtools_04_evaluate_test_model_dvc


pipeline1: us1-step1 us1-step2 us1-step3 us1-step4 us1-step5 us1-step6
	dvc run -f PipelineUseCase1.dvc -d ./poc/data/metrics.txt -d ./poc/data/metrics_test.txt \
			cat ./poc/data/metrics.txt ./poc/data/metrics_test.txt
	echo 'Use Case 1: end of pipeline'


us2-step1:
	cp ./resources/03_bis_Classify_text.ipynb ./poc/pipeline/notebooks/03_Classify_text.ipynb
	sed -i 's#\[REPLACE_CSV_INPUT\]#./poc/data/data_train_tokenized.csv#g' ./poc/pipeline/notebooks/03_Classify_text.ipynb
	sed -i 's#\[REPLACE_MODEL_OUT_BIN_PATH\]#./poc/data/fasttext_model.bin#g' ./poc/pipeline/notebooks/03_Classify_text.ipynb
	sed -i 's#\[REPLACE_MODEL_OUT_VEC_PATH\]#./poc/data/fasttext_model.vec#g' ./poc/pipeline/notebooks/03_Classify_text.ipynb
	ipynb_to_python -n ./poc/pipeline/notebooks/03_Classify_text.ipynb -f
	gen_dvc -i ./poc/pipeline/steps/mlvtools_03_classify_text.py -f
	./poc/commands/dvc/mlvtools_03_classify_text_dvc

pipeline2: us2-step1
	dvc repro ./PipelineUseCase1.dvc -v

us3-step1:
	cp ./resources/03_bis_Classify_text.ipynb ./poc/pipeline/notebooks/
	sed -i 's#\[REPLACE_CSV_INPUT\]#./poc/data/data_train_tokenized.csv#g' ./poc/pipeline/notebooks/03_bis_Classify_text.ipynb
	sed -i 's#\[REPLACE_MODEL_OUT_BIN_PATH\]#./poc/data/fasttext_model_bis.bin#g' ./poc/pipeline/notebooks/03_bis_Classify_text.ipynb
	sed -i 's#\[REPLACE_MODEL_OUT_VEC_PATH\]#./poc/data/fasttext_model_bis.vec#g' ./poc/pipeline/notebooks/03_bis_Classify_text.ipynb
	ipynb_to_python -n ./poc/pipeline/notebooks/03_bis_Classify_text.ipynb -f
	gen_dvc -i ./poc/pipeline/steps/mlvtools_03_bis_classify_text.py -f
	./poc/commands/dvc/mlvtools_03_bis_classify_text_dvc

us3-step2:
	cp ./poc/commands/dvc/mlvtools_04_evaluate_model_dvc ./poc/commands/dvc/mlvtools_04_bis_evaluate_model_dvc
	sed -i 's#MODEL_FILE="./poc/data/fasttext_model.bin"#MODEL_FILE="./poc/data/fasttext_model_bis.bin"#g' \
		./poc/commands/dvc/mlvtools_04_bis_evaluate_model_dvc
	sed -i 's#RESULT_FILE="./poc/data/metrics.txt"#RESULT_FILE="./poc/data/metrics_bis.txt"#g' \
		./poc/commands/dvc/mlvtools_04_bis_evaluate_model_dvc
	sed -i 's#MLV_DVC_META_FILENAME="mlvtools_04_evaluate_model.dvc"#MLV_DVC_META_FILENAME="mlvtools_04_bis_evaluate_model.dvc"#g' \
				./poc/commands/dvc/mlvtools_04_bis_evaluate_model_dvc
	./poc/commands/dvc/mlvtools_04_bis_evaluate_model_dvc

us3-step3:
	cp ./poc/commands/dvc/mlvtools_04_evaluate_test_model_dvc ./poc/commands/dvc/mlvtools_04_bis_evaluate_test_model_dvc
	sed -i 's#MODEL_FILE="./poc/data/fasttext_model.bin"#MODEL_FILE="./poc/data/fasttext_model_bis.bin"#g' \
		./poc/commands/dvc/mlvtools_04_bis_evaluate_test_model_dvc
	sed -i 's#RESULT_FILE="./poc/data/metrics_test.txt"#RESULT_FILE="./poc/data/metrics_test_bis.txt"#g' \
		./poc/commands/dvc/mlvtools_04_bis_evaluate_test_model_dvc
	sed -i 's#MLV_DVC_META_FILENAME="mlvtools_04_evaluate_test_model.dvc"#MLV_DVC_META_FILENAME="mlvtools_04_bis_evaluate_test_model.dvc"#g' \
				./poc/commands/dvc/mlvtools_04_bis_evaluate_test_model_dvc
	./poc/commands/dvc/mlvtools_04_bis_evaluate_test_model_dvc

pipeline3: us3-step1 us3-step2 us3-step3
	dvc run -f PipelineUseCase2.dvc -d ./poc/data/metrics_bis.txt -d ./poc/data/metrics_test_bis.txt \
		cat ./poc/data/metrics_bis.txt ./poc/data/metrics_test_bis.txt
	echo 'Use Case 3: end of pipeline'

us4-step1:
	$(call run_step,05_Tune_hyperparameters_with_crossvalidation.ipynb,05_tune_hyperparameters_with_crossvalidation)

pipeline4: us4-step1
	echo 'Use Case 4: end of pipeline'


define run_dummy_step
	# Copy resource to project pipeline directory
	# and then open the notebook, read info about parameters and try it.
	cp ./resources/dummy/$(1) ./dummy/pipeline/notebooks/
	# Convert to Python 3 script
	ipynb_to_python -n ./dummy/pipeline/notebooks/$(1) -f
	# Generate commands
	gen_dvc -i ./dummy/pipeline/steps/mlvtools_$(2).py -f
	# Run
	./dummy/dvc/mlvtools_$(2)_dvc
endef

dummy-setup: dummy-struct dummy-input dummy-conf
	dvc init

dummy-step1:
	dvc add ./dummy/data/dummy_pipeline_feed.txt
	$(call run_dummy_step,step1_sanitize_data.ipynb,step1_sanitize_data)

dummy-step2:
	$(call run_dummy_step,step2_split_data.ipynb,step2_split_data)

dummy-step3:
	$(call run_dummy_step,step3_convert_binaries.ipynb,step3_convert_binaries)

dummy-step4:
	$(call run_dummy_step,step4_convert_octals.ipynb,step4_convert_octals)

dummy-step5:
	$(call run_dummy_step,step5_sort_data.ipynb,step5_sort_data)

dummy: dummy-step1 dummy-step2 dummy-step3 dummy-step4 dummy-step5
	echo "Dummy pipeline end"
