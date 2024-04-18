package org.zerock.mapper;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;

import java.util.List;

public interface BoardMapper {

    //@Select("select * from tbl_board where bno > 0")
    public List<BoardVO> getList();

    /* select list with paging */
    public List<BoardVO> getListWithPaging(Criteria cri);

    /* select total count */
    public int getTotalCount(Criteria cri);

    /* create(insert) */
    public void insert(BoardVO board);

    public void insertSelectKey(BoardVO board);

    /* read(select) */
    public BoardVO read(Long bno);

    /* delete */
    public int delete(Long bno);

    /* update */
    public int update(BoardVO board);

    public void updateReplyCnt(@Param("bno") Long bno, @Param("amount") int amount);

}
