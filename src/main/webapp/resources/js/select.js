function validateSearch() {
    const userno = document.getElementById('userno').value.trim();
    if (userno === '') {
        alert('검색어를 입력하세요.');
        return false;
    }
    return true;
}