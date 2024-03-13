package org.zerock.mapper;

import org.apache.ibatis.annotations.Select;
import org.zerock.domain.BoardVO;

import java.util.List;

public interface BoardMapper {

    //@Select("select * from tbl_board where bno > 0")
    public List<BoardVO> getList();

    /* create(insert) */
    public void insert(BoardVO board);

    public void insertSelectKey(BoardVO board);

    /* read(select) 처리 */
    public BoardVO read(Long bno);


}
