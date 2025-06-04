function updatePurposeText() {
	const select = document.getElementById("purposeSelect");
	const value = select.value;
	select.setAttribute("data-selected", value);
}

 window.onbeforeprint = () => {
	const select = document.getElementById("purposeSelect");
	const parent = select.parentNode;
	const textNode = document.createElement("span");
	textNode.textContent = select.value;
	textNode.className = "print-purpose";
	parent.replaceChild(textNode, select);
};