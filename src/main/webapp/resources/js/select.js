function validateSearch() {
    const keyword = document.getElementById('keyword').value.trim();
    if (keyword === '') {
        alert('검색어를 입력하세요.');
        return false;
    }
    return true;
}