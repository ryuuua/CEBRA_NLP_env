# ベース：NGC PyTorch 24.08（CUDA 12.x）
FROM nvcr.io/nvidia/pytorch:24.08-py3

# pip root警告を抑制（任意）
RUN mkdir -p /root/.config/pip \
 && printf "[global]\nroot-user-action = ignore\n" > /root/.config/pip/pip.conf

# 依存をイメージに焼く（torch系は上書きしない）
# cuDF 24.6.0 と整合のため pandas を 2.1.x 固定
COPY requirements.gpu.txt /tmp/requirements.gpu.txt
RUN pip install -U "pip>=24.2" \
 && pip install -U --upgrade-strategy only-if-needed \
      "pandas==2.1.4" \
      -r /tmp/requirements.gpu.txt \
      faiss-gpu-cu12 optimum \
 && rm -rf /root/.cache/pip

# 再現性のメタ情報（任意）
RUN python - <<'PY'
import os, subprocess
print("=== FREEZE START ===")
subprocess.run(["pip","freeze"])
print("=== FREEZE END ===")
PY

WORKDIR /workspace/CEBRA_NLP
