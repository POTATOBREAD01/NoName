function updatePurposeText(radio) {
	const selectedPurpose = radio.value;
    document.getElementById('selectedPurposeText').textContent = selectedPurpose;
}

 window.onbeforeprint = () => {
	const select = document.getElementById("purposeSelect");
	const parent = select.parentNode;
	const textNode = document.createElement("span");
	textNode.textContent = select.value;
	textNode.className = "print-purpose";
	parent.replaceChild(textNode, select);
};

function updatePurposeText(radio) {
    const selectedPurpose = radio.value;
    document.getElementById('selectedPurposeText').textContent = "" + selectedPurpose;
}

// 페이지 로드 시 초기값 설정
window.addEventListener('DOMContentLoaded', () => {
    const selected = document.querySelector('input[name="purpose"]:checked');
    if (selected) {
        updatePurposeText(selected);
    }
});